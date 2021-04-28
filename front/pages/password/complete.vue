<template lang="pug">
c-layout(center)
  .white.pa-8.mt-3.pb-12.text-center
    h1.text-h3.font-weight-bold.darkgray--text.mb-12(:class="isMobile && 'text-left'") パスワードのリセット完了
    h6.subtitle-2 入力いただいたメールアドレスに 
    h6.subtitle-2 新しいパスワードを送付いたしました。
    p.auth__link-top.pt-1
      nuxt-link.subtitle-2(to="/")
        | ホームケアナビトップに戻る
</template>

<script>
export default {};
</script>
