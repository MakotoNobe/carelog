<template lang="pug">
c-layout(center)
  .white.pa-4.mt-3.pb-12
    .text-right(:class="isMobile && 'position_title'")
      nuxt-link.text-subtitle-2.primary--text.text-decoration-none(
        to="/signin"
      )
        | ログインはこちら
    v-card.mx-auto(width="520", flat)
      h1.text-h3.font-weight-bold.darkgray--text(
        :class="(isMobile && 'text-left') || 'text-center'"
      ) 新規登録
      ul.notice(v-if="!errorMessages.length == 0")
        li.notice__item(v-for="(msg, index) in errorMessages", :key="index")
          | {{ msg }}
      ValidationObserver(ref="obs", v-slot="{ invalid }")
        v-form.form(@submit.prevent="submitSignUp")
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required",
              name="お名前"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | お名前
              v-text-field(
                type="text",
                autocomplete="name",
                placeholder="田中 太郎",
                v-model="user.name",
                @focus="resetVilidMessage",
                single-line,
                outlined,
                style="max-width: 343px",
                hide-details
              )
              p.primary--text.text-body-2 {{ errors[0] }}
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required|email",
              name="メールアドレス"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | メールアドレス
              v-text-field(
                type="email",
                autocomplete="email",
                placeholder="homecarenavi@mail.com",
                v-model="user.email",
                @focus="resetVilidMessage",
                single-line,
                outlined,
                hide-details
              )
              p.primary--text.text-body-2 {{ errors[0] }}
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required|min:8",
              name="パスワード"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | パスワード
              v-text-field(
                type="password",
                placeholder="半角英数字8文字以上",
                v-model="user.password",
                @focus="resetVilidMessage",
                single-line,
                outlined,
                hide-details
              )
              p.primary--text.text-body-2 {{ errors[0] }}
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required|tel",
              name="電話番号"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | 電話番号
              v-text-field(
                type="tel",
                autocomplete="tel",
                placeholder="08012345678",
                v-model="user.tel",
                maxlength="13",
                @input="telWatch",
                @focus="resetVilidMessage",
                single-line,
                outlined,
                hide-details
              )
              p.primary--text.text-body-2 {{ errors[0] }}
          .form__group
            ValidationProvider(
              v-slot="{ errors, classes }",
              mode="lazy",
              rules="required|postalCode",
              name="郵便番号"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | 住所
              v-row.d-flex.align_item_center.mb-2.gray--text
                v-col.py-0(cols="auto")
                  span 〒
                v-col.py-0.pl-0
                  v-text-field(
                    type="postal-code",
                    name="postal-code",
                    @blur="searchAddress",
                    placeholder="0000000",
                    v-model="user.postcode",
                    @focus="resetVilidMessage",
                    single-line,
                    outlined,
                    style="max-width: 107px",
                    hide-details
                  )
                  span.primary--text.text-body-2 {{ errors[0] }}
            ValidationProvider(
              v-slot="{ errors, classes }",
              rules="required",
              name="住所"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
              v-text-field(
                type="text",
                name="address",
                :placeholder="placeholder",
                v-model="user.address",
                @focus="resetVilidMessage",
                single-line,
                outlined,
                hide-details
              )
              p.primary--text.text-body-2 {{ errors[0] }}
          .mt-8
            v-btn(
              type="submit",
              :disabled="invalid",
              large,
              block,
              depressed,
              color="primary"
            ) 新規登録
</template>

<script>
import { AsYouType } from "libphonenumber-js";

export default {
  data() {
    return {
      user: {
        name: "",
        email: "",
        password: "",
        tel: "",
        postcode: "",
        address: "",
      },
      errorMessages: [],
      addresses: {
        zipcode: "",
        addressData: {},
      },
      placeholder: "東京都世田谷区祖師谷4-3-15",
      formFocus: false,
    };
  },
  methods: {
    async submitSignUp() {
      const url = "/api/signup";
      await this.$axios
        .$post(url, {
          name: this.user.name,
          email: this.user.email,
          password: this.user.password,
          tel: this.user.tel,
          postcode: this.user.postcode,
          address: this.user.address,
        })
        .then(() => {
          this.$router.push({ path: "/signup/confirm" });
        })
        .catch((error) => {
          if (error.response.status === 422) {
            error.response.data.errors.full_messages.forEach((message) => {
              this.errorMessages.push(message);
            });
          }
        });
    },
    async searchAddress() {
      this.placeholder = "";
      await this.$axios
        .$get(`/postcode/search?zipcode=${this.user.postcode}`)
        .then((res) => {
          if (res.results === null && res.message === null) {
            return (this.placeholder =
              "該当の郵便番号が見つかりませんでした。");
          } else if (res.status === 400) {
            return (this.placeholder = "郵便番号の桁数が不正です。");
          } else {
            const result = res.results[0];
            return (this.user.address = `${result.address1}${result.address2}${result.address3}`);
          }
        });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
    telWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.user.tel)) {
        // 整形する関数
        const formatTel = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatTel(this.user.tel);
        this.user.tel = formatedPhoneNumber;
      }
    },
  },
};
</script>
<style lang="scss" scoped>
.align_item_center {
  align-items: center;
}

.position_title {
  position: absolute;
  right: 16px;
  left: 16px;
  z-index: 2;
}
</style>
