<template lang="pug">
  c-layout(center)
    div.white.pa-4
      h1.mb-0(:class="!isMobile && 'text-h3'||'text-h4' ") お問い合わせ
        form.p-form(v-on:submit.prevent="submit", v-if="showForm")
          div.form__group
            p.body-1.font-weight-bold.gray--text.mb-2.pt-6(for="userName") お名前
            v-text-field(type="text" required="" v-model="userName" placeholder="田中太郎" outlined hide-details) 
          div.form__group
            p.body-1.font-weight-bold.gray--text.mb-2.mb-2.pt-6(for="email") 返信用メールアドレス
            v-text-field(type="text" required="" v-model="email" placeholder="homecarenavi@mail.com" outlined hide-details)
          div.form__group
            p.body-1.font-weight-bold.gray--text.mb-2.pt-6(for="contactType") 利用者区分
            v-select(v-model="contactType", required="" :items="items" placeholder="ユーザー" outlined hide-details) 
          div.form__group
            p.body-1.font-weight-bold.gray--text.mb-2.pt-6(for="content") お問い合せ内容
            v-textarea(v-model="content", required="" flat outlined placeholder="入力してください" height="261")
          div.form__group
            v-btn(:x-large="!isMobile", :large="isMobile" color= "primary" depressed type="submit" :disabled="invalid" block)
             | この内容で問い合わせる
        div.form__group.body-1.text-center(v-else)
          p.mb-1.mt-8 お問い合わせが完了しました。
          p.mt-1 3営業日以内にご返答させていただきますので、今しばらくお待ちください。
          p
            nuxt-link.text-decoration-none(to="/") TOPへ戻る
</template>

<script>
import axios from "axios";

export default {
  data: () => ({
    showForm: true,
    userName: "",
    email: "",
    contactType: "",
    content: "",
    items: ["ユーザー", "ケアマネージャー", "事業所", "その他"],
  }),
  methods: {
    submit() {
      const submitParams = new FormData();
      submitParams.append("entry.1565388355", this.userName);
      submitParams.append("entry.2074345703", this.email);
      submitParams.append("entry.726436997", this.contactType);
      submitParams.append("entry.1641647196", this.content);
      const CORS_PROXY = "https://cors-anywhere.herokuapp.com/";
      const GOOGLE_FORM_ACTION =
        "https://docs.google.com/forms/u/0/d/e/1FAIpQLSdrlhhXFe_ez2W-UayrKAMOOW_P2AWlkPUxNyi2RwnYMmg2nw/formResponse";
      axios.post(CORS_PROXY + GOOGLE_FORM_ACTION, submitParams).then(() => {
        this.showForm = false;
      });
    },
  },
};
</script>
