<template lang="pug">
c-layout(center)
  v-card-title.white.py-0.pt-2(
    :class="(!isMobile && 'd-block') || 'd-flex flex-row-reverse justify-space-between'"
  )
    p(
      :class="(!isMobile && 'text-right text-subtitle-2') || 'align-center subtitle-2'"
    )
      nuxt-link.text-decoration-none(to="/signin/office") ケアマネジャーの方はこちら
    h1.text-decoration-none.font-weight-bold.darkgray--text(
      to="/signin/office",
      :class="(!isMobile && 'text-h3 text-center mb-0') || 'text-h4 text-left pt-4'"
    ) ログイン
  .white(:class="(isMobile && 'pa-4') || 'pb-4'")
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
                placeholder="homecarenavi@mail.com",
                required,
                v-model="user.email",
                outlined,
                :error-messages="errors[0]"
              )
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              rules="required|min:8",
              name="パスワード"
            )
              p.body-1.font-weight-bold.gray--text.mb-2 パスワード
              v-text-field(
                type="password",
                placeholder="半角英数字8文字以上",
                v-model="user.password",
                outlined,
                hide-details,
                :error-messages="errors[0]"
              )
          p.text-right.mb-8
            nuxt-link.gray--text.text-subtitle-2.text-decoration-none(
              to="/password/new"
            ) パスワードを忘れた
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
              | ログイン
            p.text-center.pa-1
              nuxt-link.text-decoration-none(to="/signup") 新規登録はこちら
</template>

<script>
import Cookies from "js-cookie";
import Clayout from "@/components/c-layout.vue";

export default {
  name: "signin",
  components: {
    Clayout,
  },
  data() {
    return {
      user: {
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
      const url = "/api/v1/signin";
      await this.$axios
        .post(url, {
          email: this.user.email,
          password: this.user.password,
        })
        .then((response) => {
          if (response.headers.client) {
            alert(JSON.stringify(response.data.data.name));
            Cookies.set("access-token", response.headers["access-token"]);
            Cookies.set("client", response.headers.client);
            Cookies.set("uid", response.headers.uid);
            Cookies.set(
              "user-name",
              encodeURIComponent(response.data.data.name)
            );
            Cookies.set("token-type", response.headers["token-type"]);
            Cookies.set("user", "true");
            Cookies.set("login-status", "true");
          }
          this.$router.push({ path: "/" });
        })
        .catch(() => {
          // if (error.response.status === 401) {
          //   error.response.data.errors.forEach((message) => {
          //     this.errorMessages.push(message);
          //   });
          // }
        });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
  },
};
</script>
