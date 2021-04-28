<template lang="pug">
c-layout(center)
  v-card.mx-auto(width="520", flat, color="transparent")
    v-row.text-center(align="center", justify="center")
      v-col(cols="12")
        v-icon(size="80", color="gray") mdi-emoticon-sad-outline
      v-col.py-0(cols="12")
        .text-subtitle-1(v-if="error.statusCode === 404") {{ pageNotFound }}
        .text-subtitle-1(v-else) {{ otherError }}
      v-col(cols="12")
        v-btn.mt-6(large, color="primary", to="/", depressed) ホームページ
</template>

<script>
export default {
  props: {
    error: {
      type: Object,
      default: null,
    },
  },
  data() {
    return {
      pageNotFound: "404ページが見つかりません",
      otherError: "エラーが発生しました",
    };
  },
  head() {
    const title =
      this.error.statusCode === 404 ? this.pageNotFound : this.otherError;
    return {
      title,
    };
  },
};
</script>

<style scoped>
h1 {
  font-size: 20px;
}
</style>
