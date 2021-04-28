<template lang="pug">
  c-layout(center)
    div.white.pa-4.mt-3
      v-card.mx-auto(width="520", flat)
        h1.font-weight-bold.darkgray--text.mt-4(:class="isMobile && 'text-h4'||'text-center text-h3' ") パスワードの再設定
        ValidationObserver(ref="obs" v-slot="{ validate }")
          form.form(@submit.prevent="submitResetPassword")
            div.form__group
              ValidationProvider(v-slot="{ errors, classes }" mode="passive" rules="required|min:8|confirmed:confirmation" name="パスワード")
                p.body-1.font-weight-bold.gray--text.mb-2(:class="(!isMobile && 'pt-2') || 'pt-0'") パスワード
                v-text-field(type="password",placeholder="半角英数字8文字以上",v-model="user.password",outlined,:error-messages="errors[0]",hide-details)
            div.form__group
              ValidationProvider(v-slot="{ errors, classes }" mode="passive" rules="required|min:8" vid="confirmation" name="パスワード（確認用）")
                p.body-1.font-weight-bold.gray--text.mb-2(:class="(!isMobile && 'pt-1 mt-4') || 'pt-0 mt-4'") パスワード（確認用）
                v-text-field(type="password",placeholder="半角英数字8文字以上",v-model="user.password_confirmation",outlined,:error-messages="errors[0]")
            div.mb-10
              v-btn(
                :x-large="!isMobile",
                :large="isMobile",
                 @click="validate()"
                color="primary",
                depressed,
                type="submit",
                block
              ) パスワードをリセットする
</template>

<script>
export default {
  data() {
    return {
      user: {
        password: "",
        password_confirmation: "",
      },
      headers: {
        uid: "",
        client: "",
        "access-token": "",
      },
    };
  },
  mounted() {
    const url = location.href;
    // 引数で受け取ったURLをオブジェクト形式に変換する処理
    function convertParamsToObject(url) {
      const regexp = /[?&]([^=#]+)=([^&#]*)/g;
      const paramsObj = {};
      let matchElement;
      while ((matchElement = regexp.exec(url))) {
        paramsObj[matchElement[1]] = matchElement[2];
      }
      return paramsObj;
    }
    // クエリパラメーターを分解してdataに保持させる処理
    this.headers.uid = decodeURIComponent(convertParamsToObject(url).uid);
    this.headers.client = convertParamsToObject(url).client;
    this.headers["access-token"] = convertParamsToObject(url)["access-token"];
  },
  methods: {
    async submitResetPassword() {
      const url = "/api/password";
      await this.$axios
        .$put(url, this.user, { headers: this.headers })
        .then((res) => {
          console.log(res);
          this.$router.push({ path: "/password/reset-confirm" });
        })
        .catch((res) => {
          console.log(res);
        });
    },
  },
};
</script>
