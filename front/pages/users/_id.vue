<template lang="pug">
c-layout(center)
  .white.pa-4.mt-3.pb-12
    .text-right(:class="isMobile && 'position_title'")
      nuxt-link.text-subtitle-2.primary--text.text-decoration-none(
        :to="{ path: `/users/edit/${user.id}` }"
      )
        | 変更する
    .mx-auto
      h1.text-h3.font-weight-bold.darkgray--text(
        :class="(isMobile && 'text-left') || 'text-center'"
      ) 登録情報
    v-row.justify-center
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.gray--text.mb-1 お名前
        p.user-wrap__text
          | {{ user.name }}
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.mb-0.gray--text.mb-1 メールアドレス
        p.user-wrap__text
          | {{ user.email }}
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.mb-0.gray--text.mb-1 パスワード
        p.user-wrap__text 非表示
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.mb-0.gray--text.mb-1 電話番号
        p.user-wrap__text
          | {{ user.tel }}
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.mb-0.gray--text.mb-1 住所
        p.user-wrap__text
          span
            | 〒{{ user.postcode }}
          br
          span
            | {{ user.address }}
    v-card-text.text-center.mt-8.px-0
      button.primary--text(@click="logout")
        | ログアウト
  v-card-text.text-center.white.pa-0.mt-6(
    :style="{ height: '64px', 'line-height': '64px' }",
    :class="isMobile && 'mb-6'"
  )
    nuxt-link.text-decoration-none.d-block.font-weight-bold(
      to="/users/withdraw"
    )
      | 退会する
</template>

<script>
import Cookies from "js-cookie";

export default {
  middleware: "redirect",
  data() {
    return {
      user: {},
    };
  },
  async created() {
    const url = "/api/v1/users";
    const headers = {
      uid: Cookies.get("uid"),
      client: Cookies.get("client"),
      "access-token": Cookies.get("access-token"),
    };
    await this.$store.dispatch("user/getUserData", {
      url,
      headers,
    });
    this.user = await this.$store.state.user.data;
  },
  methods: {
    logout() {
      this.$nuxt.$emit("logoutSet", "user");
    },
  },
};
</script>
