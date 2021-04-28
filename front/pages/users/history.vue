<template lang="pug">
c-layout(center)
  .px-3(:class="{ 'py-3': isMobile }")
    h1.mb-0.text-h4.font-weight-bold.darkgray--text 閲覧履歴
    p.text-body-1.gray--text.mb-1(v-if="!isEmpty") {{ `最新${offices.length}件` }}
    v-row(v-if="offices.length")
      v-col(
        v-for="(office, index) in offices",
        :key="index",
        cols="12",
        md="6"
      )
        c-card.mb-3(
          :key="index",
          :office="office",
          :toggleBookmark="addBookmark"
        )
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
        ) 閲覧情報がありません
        nuxt-link.text-subtitle-2.primary--text.text-decoration-none(to="/") ホームケアナビトップに戻る
</template>

<script>
import CCard from "@/components/c-card";

export default {
  middleware: "redirect",
  components: {
    CCard,
  },
  data() {
    return {
      offices: [],
      page: {
        currentPage: 1,
        totalPage: 1,
      },
      holidays: [],
    };
  },
  computed: {
    showThanksComment() {
      const noMessage = "まだ口コミはありません。";
      return (value) => {
        if (value === "no" || value.thanks.length === 0) {
          return noMessage;
        } else {
          return value.thanks[0].body;
        }
      };
    },
    isEmpty() {
      return !this.offices.length;
    },
  },
  mounted() {
    this.gethistory();
  },
  methods: {
    async gethistory() {
      const url = "api/users/history";
      await this.$axios.get(url).then((response) => {
        const holidays = [];
        this.page.totalPage = Number(response.headers["total-pages"]);
        this.offices = response.data;
        this.offices.forEach(function (office) {
          office.regular_holidays.forEach(function (day) {
            holidays.push(day.holiday);
          });
        });
      });
    },
    async changePage(val) {
      await this.$axios.get(`api/users/history?page=${val}`).then((res) => {
        this.offices = res.data;
        this.$vuetify.goTo(0);
      });
    },
    async addBookmark(id) {
      if (confirm("ブックマークに追加しますか？")) {
        await this.$axios.post("/api/v1/users/bookmarks", {
          office_id: id,
        });
      }
    },
  },
};
</script>
