<template lang="pug">
v-footer(height="50", absolute, color="white", padless)
  v-row(justify="center", align="center")
    v-btn(text, @click="$router.push({ name: 'index' })")
      strong ホームケアナビ
    v-spacer
    v-btn(text, @click="$router.push({ name: 'privacy_policy' })")
      | プライバシーポリシー
    v-btn(text, @click="$router.push({ name: 'terms' })")
      | 利用規約
    v-btn(text, @click="$router.push({ name: 'contact' })")
      | お問い合わせ
</template>
<script>
export default {
  name: "Footer",
};
</script>
