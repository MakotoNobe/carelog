<template lang="pug">
c-layout(center)
  .px-3(:class="{ 'mt-4': isMobile }")
    h1.text-h3.font-weight-bold.mb-2 お礼一覧
    c-row(small, v-if="thanks.length")
      v-col(v-for="(thank, index) in thanks", :key="index", cols="12", md="6")
        v-card.pa-3.mb-3
          v-row
            v-col.py-0.d-flex
              .text-subtitle-2.font-weight-bold.darkgray--text {{ thank.user.name }}さん
            v-col.py-0.text-right
              .text-overline.font-weight-regular.gray--text {{ $moment(thank.created_at).format('YYYY年MM月DD日 HH:mm') }}
          .mb-4.mt-1.text-body-2.font-weight-regular.gray--text {{ thank.body }}

          c-row
            v-col.py-0(cols="12")
              v-btn(block, outlined, color="bluegray", @click="destroy(index)")
                span.staffcolor--text 削除
    v-row(v-else-if="!loading")
      v-col.text-center(cols="12")
        .text-h6.gray--text.mb-4(
          :class="{ 'mt-12': !isMobile, 'mt-7': isMobile }"
        ) 何もデータが見つかりませんでした
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
      thanks: [],
      loading: false,
    };
  },

  mounted() {
    this.getData();
  },

  methods: {
    async getData() {
      this.loading = true;
      const url = "/api/staffs/thanks";
      await this.$axios
        .get(url, {
          email: Cookies.get("uid"),
        })
        .then((response) => {
          this.thanks = response.data;
        })
        .catch((error) => {
          console.log(error);
        });
      this.loading = false;
    },

    async destroy(index) {
      const id = this.thanks[index].id;
      const url = `/api/staffs/thanks?thank_id=${id}`;
      const result = confirm("削除してもよろしいでしょうか？");
      if (result) {
        this.thanks.splice(index, 1);
        await this.$axios.delete(url);
      }
    },
  },
};
</script>
