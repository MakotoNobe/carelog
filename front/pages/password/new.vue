<template lang="pug">
c-layout(center)
  v-card.title.mx-auto(flat, :class="(!isMobile && 'pa-8') || 'pa-4'")
    h1.font-weight-bold(
      :class="(!isMobile && 'text-h3 text-center') || 'text-h4'"
    ) パスワードのリセット
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      .white
        v-card.mx-auto(width="520", flat)
          form.form(@submit.prevent="sentMail")
            .form__group
              ValidationProvider(
                v-slot="{ errors, classes }",
                rules="required|email",
                name="メールアドレス"
              )
                p.body-1.font-weight-bold.gray--text.mb-2 メールアドレス
                v-text-field(
                  type="email",
                  name="email",
                  autocomplete="email",
                  placeholder="例）homecarenavi@mail.com",
                  v-model="user.email",
                  outlined,
                  @focus="resetVilidMessage",
                  :error-messages="errors[0]"
                )
            p.form__alert(v-show="errorMessage")
              | メールアドレスは見つかりませんでした。
            .form__group
              v-btn(
                :x-large="!isMobile",
                :large="isMobile",
                color="primary",
                depressed,
                type="submit",
                :disabled="invalid",
                block
              )
                | パスワードをリセットする
              p.text-center.pa-1-pb-14
                p.text-decoration-none.text-center(
                  @click="$router.back()",
                  type="submit"
                ) リセットせずにもどる
</template>

<script>
export default {
  data() {
    return {
      user: {
        email: "",
      },
      errorMessage: false,
    };
  },
  methods: {
    async sentMail() {
      const url = "/api/password";
      await this.$axios
        .$post(url, {
          email: this.user.email,
        })
        .then(() => {
          this.$router.push({ path: "/password/confirm" });
        })
        .catch((error) => {
          if (error.response.status === 404) {
            this.errorMessage = true;
          }
        });
    },
    resetVilidMessage() {
      this.errorMessage = false;
    },
  },
};
</script>
