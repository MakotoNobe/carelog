<template lang="pug">
c-layout(center)
  .white.pa-4(:class="{ 'text-center': !isMobile, 'mt-3': isMobile }")
    v-card.mx-auto(width="520", flat)
      v-dialog(
        v-model="dialog",
        max-width="300px",
        overlay-color="darkgray",
        :overlay-opacity="0.8",
        :persistent="loading"
      )
        template(v-slot:activator="{ on, attrs }")
          div
            h1.darkgray--text(
              :class="{ 'text-h3': !isMobile, 'text-h4': isMobile }"
            ) 退会
            .text-subtitle-2.darkgray--text
              | 退会後はこれまでの予約情報などは全て削除されます。
              br
              br
              | また以下の機能が使用できなくなります。
              br
              br
              | ・ブックマーク
              br
              | ・予約
              br
              | ・お礼投稿
              v-btn.mt-8(
                v-bind="attrs",
                v-on="on",
                :x-large="!isMobile",
                :large="isMobile",
                color="primary",
                depressed,
                block
              )
                | 退会する
            p.text-center.mt-2
              a.text-subtitle-2(
                @click="$router.push({ path: '/users', name: 'users-id' })"
              )
                | 退会せずに戻る
        v-card
          v-card-text.pt-10.pb-4.text-h6.text-center 本当に退会しますか？
          v-row
            v-col(cols="5")
              v-btn(
                outlined,
                color="bluegray",
                depressed,
                block,
                @click="dialog = false",
                :loading="loading"
              )
                span.text-subtitle-2.font-weight-bold.primary--text キャンセル
            v-col(cols="7")
              v-btn(
                color="primary",
                @click="withdraw",
                @click.stop="logout",
                block,
                depressed,
                :loading="loading"
              )
                span.text-subtitle-2.font-weight-bold 退会する
</template>

<script>
export default {
  // props: {
  //   logout: {
  //     type: Function,
  //     required: false,
  //     default: () => {},
  //   },
  // },
  data() {
    return {
      dialog: false,
      loading: false,
    };
  },
  methods: {
    async withdraw() {
      this.loading = true;
      const url = "/api/v1/user/withdraw";
      await this.$axios.delete(url);
      this.loading = false;
      this.$nuxt.$emit("logoutSet", "user");
    },
  },
};
</script>
