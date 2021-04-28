<template lang="pug">
c-layout(center)
  .px-3(:class="{ 'mt-4': isMobile }")
    h1.text-h3.font-weight-bold.mb-2 利用者情報管理
    c-row(small, v-if="offices.length")
      v-col(
        v-for="(office, index) in offices",
        :key="index",
        cols="12",
        md="6"
      )
        v-card.pa-3.mb-3
          v-row
            v-col.py-0.d-flex
              v-chip.px-2.primary--text(small, label, color="#F0636433", chip)
                span.font-weight-bold {{ office.reserved ? '連絡済み' : '未連絡' }}
            v-col.py-0.text-right
              .text-overline.font-weight-regular.gray--text {{ office.created_at }}
          .my-4.text-h3.font-weight-bold.darkgray--text {{ office.name }} （{{ office.age }}）

          .text-body-1.font-weight-bold.gray--text 面談希望日時
          .mb-3.text-h6.font-weight-regular.darkgray--text {{ office.date }} {{ office.time }}
          .text-body-1.font-weight-bold.gray--text 連絡先電話番号
          .mb-3.text-h6.staffcolor--text {{ office.tel }}

          c-row(small)
            v-col(cols="5")
              v-btn(block, outlined, color="bluegray", @click="destroy(index)")
                span.staffcolor--text 削除する
            v-col(cols="7")
              v-btn(
                block,
                dark,
                depressed,
                color="staffcolor",
                @click="contact(index)"
              ) 連絡済みにする
      v-col.fixed-bottom(cols="12")
        v-pagination(
          v-model="page.currentPage",
          :length="page.totalPage",
          @input="changePage",
          color="bluegray"
        )
    v-row(v-else-if="!loading")
      v-col.text-center(cols="12")
        .text-h6.gray--text.mb-4(
          :class="{ 'mt-12': !isMobile, 'mt-7': isMobile }"
        ) 予約情報がありません
        nuxt-link.text-subtitle-2.primary--text.text-decoration-none(to="/") ホームケアナビトップに戻る
    v-row(v-else)
      v-col.text-center(cols="12")
        v-progress-circular(indeterminate, color="staffcolor")
</template>

<script>
import Cookies from "js-cookie";

export default {
  data() {
    return {
      offices: [],
      offices_reserved: false,
      page: {
        currentPage: 1,
        totalPage: 1,
      },
      loading: false,
    };
  },

  mounted() {
    this.getReserved();
  },

  methods: {
    async getReserved() {
      this.loading = true;
      const url = "/api/reserved/office";
      await this.$axios
        .get(url, {
          email: Cookies.get("uid"),
        })
        .then((response) => {
          this.offices = response.data;
          this.page.totalPage = Number(response.headers["total-pages"]);
        })
        .catch((error) => {
          console.log(error);
        });
      this.loading = false;
    },
    async contact(index) {
      const id = this.offices[index].id;
      const url = `/api/reserved/office/contact?id=${id}`;
      this.offices[index].reserved = true;
      await this.$axios.get(url);
    },
    async destroy(index) {
      const id = this.offices[index].id;
      const url = `/api/reserve?id=${id}`;
      const result = confirm("削除してもよろしいでしょうか？");
      if (result) {
        this.offices.splice(index, 1);
        await this.$axios.delete(url);
        this.$axios
          .get(`api/reserved/office?page=${this.page.currentPage}`)
          .then((response) => {
            this.offices = response.data;
          });
      }
    },
    async changePage(val) {
      await this.$axios
        .get(`api/reserved/office?page=${val}`)
        .then((response) => {
          this.offices = response.data;
          this.$vuetify.goTo(0);
        });

      this.$scrollToTop();
    },
  },
};
</script>
