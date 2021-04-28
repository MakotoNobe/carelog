<template lang="pug">
c-layout(center)
  v-card-title.white.py-0.pt-2(
    :class="!isMobile ? 'd-block' : 'd-flex flex-row-reverse justify-space-between'"
  )
    p(
      :class="(!isMobile && 'text-right text-subtitle-2 mt-1 mb-0') || 'align-center subtitle-2'"
    )
      nuxt-link.text-decoration-none.admincolor--text(to="/signin/office") ケアマネの方はこちら
    h1.text-decoration-none.font-weight-bold.darkgray--text(
      to="/signin/office",
      :class="(!isMobile && 'text-h3 text-center mb-0') || 'text-h4 text-left pt-4'"
    ) {{ !isMobile ? '管理者ログイン' : '管理者ログイン' }}
  .white(:class="(isMobile && 'pa-4 pt-0') || 'pb-0'")
    v-card.mx-auto(width="520", flat)
      ul.notice(v-if="!errorMessages.length == 0")
        li.notice__item(v-for="(msg, index) in errorMessages", :key="index")
          | {{ msg }}
      ValidationObserver(ref="obs", v-slot="{ invalid }")
        form.form(@submit.prevent="submitSignIn")
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required|email",
              name="メールアドレス"
            )
              p.body-1.font-weight-bold.gray--text.mb-2(
                :class="(!isMobile && 'pt-12') || 'pt-0'"
              ) メールアドレス
              v-text-field(
                type="email",
                name="email",
                autocomplete="email",
                placeholder="例）homecarenavi@mail.com",
                required,
                v-model="admin.email",
                outlined,
                :error-messages="errors[0]",
                color="admincolor"
              )
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              rules="required|min:8",
              name="パスワード"
            )
              p.body-1.font-weight-bold.gray--text.mb-0.mt-0 パスワード
              v-text-field.mt-2(
                type="password",
                placeholder="半角英数字8文字以上",
                required,
                v-model="admin.password",
                outlined,
                :hide-details="!errors[0]",
                :error-messages="errors[0]",
                color="admincolor"
              )
          p.text-right.mb-8
            nuxt-link.gray--text.text-subtitle-2.text-decoration-none(
              to="/password/new"
            ) パスワードを忘れた
          .form__group.pb-4
            v-btn.white--text.mb-12(
              :x-large="!isMobile",
              :large="isMobile",
              color="admincolor",
              depressed,
              type="submit",
              :disabled="invalid",
              block
            )
              | ログイン
</template>

<script>
import Cookies from "js-cookie";

export default {
  data() {
    return {
      admin: {
        email: "",
        password: "",
      },
      headers: {
        uid: "",
        client: "",
        "access-token": "",
      },
      errorMessages: [],
    };
  },

  methods: {
    async submitSignIn() {
      const url = "/api/v1/admin/signin";
      await this.$axios
        .post(url, {
          email: this.admin.email,
          password: this.admin.password,
        })
        .then((response) => {
          if (response.headers.client) {
            console.log(response.data);
            Cookies.set("access-token", response.headers["access-token"]);
            Cookies.set("client", response.headers.client);
            Cookies.set("uid", response.headers.uid);
            Cookies.set("token-type", response.headers["token-type"]);
            Cookies.set(
              "user-name",
              encodeURIComponent(response.data.data.name)
            );
            Cookies.set("office-id", response.data.data.id);
            Cookies.set("admin", "true");
            Cookies.set("login-status", "true");
          }
          this.$router.push({
            path: `/admin/offices/${Cookies.get("office-id")}`,
          });
        })
        .catch((error) => {
          // if (error.response.status === 401) {
          //   error.response.data.errors.forEach((message) => {
          //     this.errorMessages.push(message);
          //   });
          // }
          console.log(error);
        });
    },
  },
};
</script>
