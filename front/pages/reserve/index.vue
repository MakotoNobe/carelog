<template lang="pug">
c-layout(center)
  v-btn.justify-start(
    v-if="!isMobile",
    x-small,
    color="primary",
    depressed,
    block,
    text,
    @click="$router.back()"
  )
    v-icon(left) mdi-chevron-left
    span.text-body-2.font-weight-regular {{ office_name }}
  .white.pa-4.mt-3
    h1.text-h3.mb-6.font-weight-bold.darkgray--text(
      :class="{ 'text-h3': !isMobile, 'text-h4': isMobile }"
    ) Web予約
    p.body-1.font-weight-bold.gray--text.mb-2 事業所名
    p.text-h6.darkgray--text.mb-6 {{ office_name }}
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      v-form
        p.body-1.font-weight-bold.gray--text.mb-2 面談希望日時
        .d-flex
          v-card(max-width="168", flat)
            v-menu(
              ref="menu1",
              v-model="menu1",
              :close-on-content-click="false",
              transition="scale-transition",
              offset-y="",
              outlined
            )
              template(v-slot:activator="{ on, attrs }")
                v-text-field(
                  :value="dateString",
                  placeholder="日付を選択して下さい",
                  v-bind="attrs",
                  v-on="on",
                  outlined,
                  readonly,
                  dense,
                  hide-details
                )
              v-date-picker(
                v-model="date",
                no-title="",
                @input="menu1 = false",
                locale="ja-jp",
                :min="$moment().format('YYYY-MM-DD')",
                :max="$moment().add(1, 'y').format('YYYY-MM-DD')",
                @change="getReserved(date, office_id)"
              )
          ValidationProvider(
            v-slot="{ errors, classes }",
            mode="lazy",
            rules="required",
            name="時間"
          )
            v-card.ml-4(max-width="168", flat)
              v-select(
                v-model="time",
                :items="items",
                placeholder="時間を選択して下さい",
                outlined,
                dense,
                hide-details,
                @focus="resetVilidMessage"
              )
            p.primary--text.text-body-2 {{ errors[0] }}
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="お名前"
        )
          p.body-1.font-weight-bold.gray--text.mb-2(:class="classes") 利用者のお名前
          v-text-field(
            type="text",
            autocomplete="name",
            placeholder="田中 太郎",
            v-model="name",
            @focus="resetVilidMessage",
            single-line,
            outlined,
            style="max-width: 343px",
            hide-details
          )
          p.primary--text.text-body-2 {{ errors[0] }}
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="年齢"
        )
          p.body-1.font-weight-bold.gray--text.mb-2 利用者の年齢
            v-card(max-width="168", flat)
              v-select(
                v-model="age",
                :items="ages",
                placeholder="年齢",
                @focus="resetVilidMessage",
                outlined,
                hide-details
              )
                template(v-slot:selection="{ item }")
                  span.darkgray--text.font-weight-regular {{ item }}歳
            p.primary--text.text-body-2 {{ errors[0] }}
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required|tel",
          name="電話番号"
        )
          p.body-1.font-weight-bold.gray--text.mb-2(:class="classes") 連絡先電話番号
          v-text-field(
            type="tel",
            autocomplete="tel",
            maxlength="13",
            placeholder="08012345678",
            v-model="tel",
            @focus="resetVilidMessage",
            @input="telWatch",
            single-line,
            outlined,
            hide-details
          )
          p.primary--text.text-body-2 {{ errors[0] }}
        p.body-1.font-weight-bold.gray--text.mb-2 お困りごと
        v-textarea(v-model="body", clearable, placeholder="入力して下さい", outlined)
        v-btn(
          :disabled="invalid",
          color="primary",
          :x-large="!isMobile",
          :large="isMobile",
          depressed,
          block,
          @click="reserveConfirm"
        ) 確認へ進む
</template>

<script>
import { AsYouType } from "libphonenumber-js";
// const maxAge = 121; // 表示したい数字より+1で設定。
// const ageRange = [...Array(maxAge).keys()];
const maxAge = 120;
const minAge = 10;
const ageRange = [...Array(maxAge - minAge + 1).keys()].map(
  (item) => item + minAge
);

export default {
  middleware: "redirect",
  data: () => ({
    date: "",
    menu1: false,
    menu2: false,
    value: null,
    items: [],
    ages: ageRange,
    age: "",
    name: "",
    tel: "",
    body: "",
    time: "",
    office_name: "",
    office_id: "",
    formFocus: false,
    errorMessages: [],
  }),

  computed: {
    dateString() {
      return this.date ? this.$moment(this.date).format("MMMDD日(ddd)") : "";
    },
  },
  mounted() {
    this.office_name = this.$store.getters.reserve.office_name;
  },
  methods: {
    async getReserved(date, id) {
      const url = `/api/reserve?date=${date}&office_id=${id}`;
      this.items = [];
      await this.$axios.$get(url).then(({ data }) => {
        this.items = data;
      });
    },
    reserveConfirm() {
      this.$store.dispatch("reserveStore", {
        reserveDate: this.date,
        reserveTime: this.time,
        reserveName: this.name,
        reserveAge: this.age,
        reserveTel: this.tel,
        reserveBody: this.body,
        reserveOfficeId: this.$store.getters.reserve.office_id,
        reserveOfficeName: this.$store.getters.reserve.office_name,
      });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
    telWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.tel)) {
        // 整形する関数
        const formatTel = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatTel(this.tel);
        this.tel = formatedPhoneNumber;
      }
    },
  },
};
</script>
