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
    p.body-1.font-weight-bold.gray--text.mb-2 面談希望日時

    p.text-h6.darkgray--text.mb-6 {{ dateString }} {{ time }}

    p.body-1.font-weight-bold.gray--text.mb-2 利用者のお名前
    p.text-h6.darkgray--text.mb-6 {{ name }}
    p.body-1.font-weight-bold.gray--text.mb-2 利用者の年齢
    p.text-h6.darkgray--text.mb-6 {{ age }}歳
    p.body-1.font-weight-bold.gray--text.mb-2 連絡先電話番号
    p.text-h6.darkgray--text.mb-6 {{ tel }}
    p.body-1.font-weight-bold.gray--text.mb-2 お困りごと
    pre.text-h6.darkgray--text.mb-6 {{ body }}

    v-btn(
      color="primary",
      :x-large="!isMobile",
      :large="isMobile",
      depressed,
      block,
      @click="submitReserve"
    ) この内容で予約する

    nuxt-link.text-subtitle-2.d-block.text-center.primary--text.mt-2.text-decoration-none(
      to="/reserve/"
    ) もどる
</template>

<script>
export default {
  data: () => ({
    date: "",
    age: "",
    name: "",
    tel: "",
    body: "",
    time: "",
    office_name: "",
    office_id: "",
  }),

  computed: {
    dateString() {
      return this.date ? this.$moment(this.date).format("MMMDD日(ddd)") : "";
    },
    reserve() {
      return this.$store.getters.reserve;
    },
    // reserve_confirm() {
    //   return this.$store.getters.reserve_confirm;
    // },
  },
  mounted() {
    this.date = this.$store.getters.reserve.date;
    this.time = this.$store.getters.reserve.time;
    this.name = this.$store.getters.reserve.name;
    this.age = this.$store.getters.reserve.age;
    this.tel = this.$store.getters.reserve.tel;
    this.body = this.$store.getters.reserve.body;
    this.office_id = this.$store.getters.reserve.office_id;
    this.office_name = this.$store.getters.reserve.office_name;
  },
  methods: {
    async submitReserve() {
      const url = "/api/reserve";
      await this.$axios
        .$post(url, {
          date: this.date,
          time: this.time,
          name: this.name,
          age: this.age,
          tel: this.tel,
          body: this.body,
          office_id: this.office_id,
        })
        .then(() => {
          this.$router.push({ path: "/reserve/complete" });
        })
        .catch((error) => {
          console.log(error);
        });
    },
  },
};
</script>
