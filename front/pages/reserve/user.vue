<template lang="pug">
c-layout(center)
  .px-3(:class="{ 'py-3': isMobile }")
    h1.mb-0.text-h3.font-weight-bold.darkgray--text.mb-4 予約履歴
    c-row.px-1(v-if="this.offices.length", small)
      v-col(
        v-for="(office, index) in offices",
        :key="index",
        cols="12",
        md="6"
      )
        v-card.pa-3(:flat="isMobile")
          .text-h4.font-weight-bold.darkgray--text {{ office.office.name }}
          v-row
            v-col(cols="auto")
              v-img(
                :src="office.office.image || '/images/no_image.png'",
                @error="office.office.image = '/images/no_image.png'",
                :width="120",
                :height="90"
              )
            v-col.pl-0
              div
                v-icon.mr-1(small, color="midgray") mdi-map-marker
                span.text-caption.darkgray--text.font-weight-regular {{ office.office.near_station }}
              div
                v-icon.mr-1(small, color="midgray") mdi-account
                span.text-caption.darkgray--text.font-weight-regular {{ office.office.staff_number }}
              div
                v-icon.mr-1(small, color="midgray") mdi-phone
                span.text-caption.darkgray--text.font-weight-regular {{ office.office.tel }}
            v-col.py-0.pt-1(cols="12")
              v-divider
            v-col.pt-2(cols="12")
              .body-2.gray--text.mt-2.mb-3 予約した日時 : {{ office.created_at }}
              .text-subtitle-1.gray--text.font-weight-bold 面談希望日時
              .darkgray--text.text-h6.mb-4 {{ office.date }} {{ office.time }}
              .text-center.text-body-1.gray--text 事業所からの連絡をお待ちください
      v-col.fixed-bottom(cols="12")
        v-pagination(
          v-model="page.currentPage",
          :length="page.totalPage",
          @input="changePage",
          color="bluegray"
        )
    v-row(v-else)
      v-col.text-center(cols="12")
        .text-h6.gray--text.mb-4(
          :class="{ 'mt-12': !isMobile, 'mt-7': isMobile }"
        ) 予約情報がありません
        nuxt-link.text-subtitle-2.primary--text.text-decoration-none(to="/") ホームケアナビトップに戻る
</template>
<script>
export default {
  middleware: "redirect",
  data() {
    return {
      offices: [],
      page: {
        currentPage: 1,
        totalPage: 1,
      },
    };
  },

  mounted() {
    this.getReserved();
  },

  methods: {
    async getReserved() {
      const url = "/api/reserved/user";
      await this.$axios
        .get(url)
        .then((response) => {
          this.offices = response.data;
          this.page.totalPage = Number(response.headers["total-pages"]);
        })
        .catch((error) => {
          console.log(error);
          this.$router.push("/");
        });
    },
    async changePage(val) {
      await this.$axios
        .get(`api/reserved/user?page=${val}`)
        .then((response) => {
          this.offices = response.data;
          this.$vuetify.goTo(0);
        });
    },
  },
};
</script>
