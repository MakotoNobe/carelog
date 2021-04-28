<template lang="pug">
c-layout(center)
  v-card.title.mx-auto(flat, :class="(!isMobile && 'pa-8') || 'pa-4'")
    h1.font-weight-bold(
      :class="(!isMobile && 'text-h3 text-center') || 'text-h4'"
    ) 事業所情報の編集
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
                  v-model="admin.email",
                  outlined,
                  @focus="resetVilidMessage",
                  :error-messages="errors[0]"
                )
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
                | メールアドレスを変更する
              p.text-center.pa-1-pb-14
                nuxt-link.text-decoration-none.text-subtitle-2(to="/") トップに戻る
</template>

<script>
import Cookies from "js-cookie";

export default {
  data() {
    return {
      admin: {
        email: "",
      },
      errorMessage: false,
    };
  },
  mounted() {
    this.admin.email = Cookies.get("uid");
  },
  methods: {
    async sentMail() {
      await this.$axios
        // ---ここ確認お願いします---
        .$put(`/admin/offices/${Cookies.get("office-id")}`, {
          email: this.admin.email,
        })
        // ----------------
        .then(() => {
          // ---ここ確認お願いします---
          this.$router.push({ path: "/signup/confirm" });
          // ----------------
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
