<template lang="pug">
c-layout(center, :container-class="isMobile ? 'pa-0' : ''")
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
    span.text-body-2.font-weight-regular {{ office.name }}
  .white.pa-4.mt-3
    h1.text-h3.font-weight-bold.mb-6 お礼の投稿
    .mb-6
      p.body-1.font-weight-bold.mb-0.gray--text 事務所名
      h6.text-h6.darkgray--text {{ office.name }}
    .mb-6
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required",
        name="スタッフ"
      )
        p.body-1.font-weight-bold.mb-0.gray--text お礼をするスタッフ
        v-select(
          v-model="selectStaff",
          :items="office.staffNames",
          placeholder="選択してください",
          outlined,
          dense,
          @focus="resetVilidMessage",
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required",
        name="お礼の内容"
      )
        .mb-1
          p.body-1.font-weight-bold.mb-0.gray--text お礼の内容
          v-textarea(
            v-model="textData",
            clearable,
            placeholder="入力してください",
            outlined,
            hide-details,
            @focus="resetVilidMessage"
          )
          p.primary--text.text-body-2 {{ errors[0] }}
      v-btn.mb-4(
        type="submit",
        x-large,
        block,
        color="primary",
        @click="postConfirm",
        :disabled="invalid"
      ) 確認へ進む
</template>

<script>
export default {
  data() {
    return {
      textData: "",
      selectStaff: "",
      formFocus: false,
      errorMessages: [],
    };
  },
  computed: {
    office() {
      return this.$store.getters.office;
    },
  },
  watch: {
    selectStaff: {
      handler() {
        console.log(this.selectStaff);
      },
    },
  },
  methods: {
    postConfirm() {
      this.$store.dispatch("postConfirmStore", {
        staff: this.selectStaff,
        thankBody: this.textData,
      });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
  },
};
</script>
