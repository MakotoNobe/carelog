<template lang="pug">
c-layout(center)
  .white.pa-4.mt-3.pb-12
    .text-right(:class="isMobile && 'position_title'")
      nuxt-link.text-subtitle-2.primary--text.text-decoration-none(
        to="/signin/admin"
      )
        | ログインはこちら
    v-card.mx-auto(width="520", flat)
      h1.text-h3.font-weight-bold.darkgray--text(
        :class="(isMobile && 'text-left') || 'text-center'"
      ) 新規事業所の作成
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
              name="事業所名"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | 事業所名
              v-text-field(
                type="text",
                autocomplete="name",
                placeholder="田中 太郎",
                v-model="office.name",
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
                v-model="office.email",
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
                v-model="office.tel",
                @focus="resetVilidMessage",
                @input="telWatch",
                maxlength="13",
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
              name="fax"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | FAX
              v-text-field(
                type="tel",
                autocomplete="tel",
                placeholder="08012345678",
                maxlength="13",
                v-model="office.fax",
                @focus="resetVilidMessage",
                @input="faxWatch",
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
                    v-model="office.postcode",
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
                v-model="office.address",
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
              rules="required",
              name="最寄り駅"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | 最寄り駅
              v-text-field(
                type="text",
                autocomplete="name",
                placeholder="新宿駅徒歩5分",
                v-model="office.near_station",
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
              rules="required",
              name="スタッフ数"
            )
              label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
                | スタッフ数
                v-card(max-width="168", flat)
                  v-select(
                    v-model="staff_number",
                    :items="ages",
                    @focus="resetVilidMessage",
                    outlined,
                    hide-details
                  )
                    template(v-slot:selection="{ item }")
                      span.darkgray--text.font-weight-regular {{ item }}人
                p.primary--text.text-body-2 {{ errors[0] }}
          .form__group
            label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
              | 経営・事業主体
            v-text-field(
              type="text",
              autocomplete="name",
              v-model="office.company",
              single-line,
              outlined,
              style="max-width: 343px",
              hide-details
            )
            p.primary--text.text-body-2
          .form__group
            label.font-weight-bold.body-1.gray--text.mb-1(:class="classes")
              | サイトURL
            v-text-field(
              type="text",
              autocomplete="name",
              v-model="office.url",
              single-line,
              outlined,
              style="max-width: 343px"
            )
          .mt-8
            v-btn(
              type="submit",
              :disabled="invalid",
              large,
              block,
              depressed,
              color="primary"
            ) 送信する
</template>

<script>
import { AsYouType } from "libphonenumber-js";
const maxAge = 120;
const minAge = 1;
const ageRange = [...Array(maxAge - minAge + 1).keys()].map(
  (item) => item + minAge
);

export default {
  data() {
    return {
      office: {
        name: "",
        email: "",
        tel: "",
        fax: "",
        postcode: "",
        address: "",
        near_station: "",
        staff_number: "",
        company: "",
        url: "",
      },
      errorMessages: [],
      addresses: {
        zipcode: "",
        addressData: {},
      },
      placeholder: "東京都世田谷区祖師谷4-3-15",
      formFocus: false,
      ages: ageRange,
    };
  },
  methods: {
    async submitSignUp() {
      const url = "/api/v1/offices/signup";
      await this.$axios
        // ---ここ確認お願いします---
        .$post(url, {
          name: this.office.name,
          email: this.office.email,
          tel: this.office.tel,
          fax: this.office.fax,
          postcode: this.office.postcode,
          address: this.office.address,
          near_station: this.office.near_station,
          company: this.office.company,
          url: this.office.url,
        })
        // ----------------
        .then(() => {
          // ---ここ確認お願いします---
          this.$router.push({ path: "/signup/confirm" });
          // ----------------
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
        .$get(`/postcode/search?zipcode=${this.office.postcode}`)
        .then((res) => {
          if (res.results === null && res.message === null) {
            return (this.placeholder =
              "該当の郵便番号が見つかりませんでした。");
          } else if (res.status === 400) {
            return (this.placeholder = "郵便番号の桁数が不正です。");
          } else {
            const result = res.results[0];
            return (this.office.address = `${result.address1}${result.address2}${result.address3}`);
          }
        });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
    telWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.office.tel)) {
        // 整形する関数
        const formatTel = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatTel(this.office.tel);
        this.office.tel = formatedPhoneNumber;
      }
    },
    faxWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.office.fax)) {
        // 整形する関数
        const formatfax = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatfax(this.office.fax);
        this.office.fax = formatedPhoneNumber;
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
