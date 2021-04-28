<template lang="pug">
c-layout(center)
  .white.pa-8.mt-3.pb-12.text-center
    h1.text-h3.font-weight-bold.darkgray--text.mb-12(:class="isMobile && 'text-left'") お礼の投稿完了
    h6.subtitle-2 お礼の投稿が完了しました。 
    h6.subtitle-2 投稿いただきありがとうございました。
    p.auth__link-top.pt-1
      nuxt-link.subtitle-2(:to="{ name: 'offices-id', params: { id: office.officeId } }")
        | 事業所のページに戻る
</template>

<script>
export default {
  computed: {
    office() {
      return this.$store.getters.office;
    },
  },
};
</script>
