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
    span.text-body-2.font-weight-regular {{ office.name }}
  .white.pa-4.mt-3
    h1.text-h3.font-weight-bold.mb-6 お礼の編集内容
    .mb-6
      p.body-1.font-weight-bold.mb-0.gray--text 事務所名
      h6.text-h6.darkgray--text {{ office.name }}
    .mb-6
      p.body-1.font-weight-bold.mb-0.gray--text お礼をするスタッフ
      h6.text-h6.darkgray--text {{ thank.staff }}
    .mb-6
      p.body-1.font-weight-bold.mb-0.gray--text お礼をするスタッフ
      h6.text-h6.darkgray--text {{ thank.body }}
    v-btn(x-large, block, color="primary", @click="editThank") この内容で更新する
    .text-center.mt-2
      nuxt-link.text-decoration-none.subtitle-2(to="/users/thanks") もどる
</template>

<script>
export default {
  computed: {
    thank() {
      return this.$store.getters.thank;
    },
    office() {
      return this.$store.getters.office;
    },
  },
  methods: {
    async editThank() {
      const targetStaff = this.$store.getters.office.staffs.find(
        (staff) => staff.name === this.$store.getters.thank.staff
      );
      const body = this.$store.getters.thank.body;
      const id = this.$store.getters.thank.id;
      await this.$axios.put(
        `/api/users/thanks?body=${body}&staff_id=${targetStaff.id}&thank_id=${id}`
      );
      this.$router.push({ name: "users-thanks-edit-complete" });
    },
  },
};
</script>
