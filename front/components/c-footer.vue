<template lang="pug">
v-footer(:height="isMobile ? 84 : 50", color="white", padless)
  v-container.d-flex.pa-0.fill-height(:class="{ 'px-0': isMobile }")
    v-row(justify="center", :class="{ 'flex-column-reverse': isMobile }")
      v-btn(text, to="/", color="white")
        span.text-subtitle-2.font-weight-bold.darkgray--text ホームケアナビ
      v-spacer
      .d-flex.justify-center
        v-btn(text, to="/privacy_policy", color="white")
          span.text-caption.font-weight-regular.primary--text プライバシーポリシー
        v-btn(text, to="/terms", color="white")
          span.text-caption.font-weight-regular.primary--text 利用規約
        v-btn(text, to="/contact", color="white")
          span.text-caption.font-weight-regular.primary--text お問い合わせ
</template>
<script>
export default {
  name: "Footer",
};
</script>
