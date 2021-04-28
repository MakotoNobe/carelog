<template lang="pug">
c-layout(center) 
  .white.px-4.py-8.mt-3.text-center
    h1.text-h3.mb-12.font-weight-bold.darkgray--text(
      :class="{ 'text-h3': !isMobile, 'text-h4': isMobile }"
    ) Web予約完了
    .subtitle-2.darkgray--text.mb-4 ご予約が完了致しました
      br
      | 事業所からのご連絡をお待ちください。
    nuxt-link.d-block.subtitle-2.primary--text.text-decoration-none.mb-8(
      to="/"
    )
      | ホームケアナビトップに戻る
</template>

<script>
export default {
  components: {},
};
</script>
