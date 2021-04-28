<template lang="pug">
c-layout(center)
  .white.pa-4.mt-3.pb-12
    .mx-auto
      h1.text-h3.font-weight-bold.darkgray--text(
        :class="(isMobile && 'text-left') || 'text-center'"
      ) スタッフ情報
    v-row.justify-center
      v-col(cols="auto")
        v-avatar(size="120")
          v-img(
            :src="staff.image || '/images/default.png'",
            @error="staff.image = '/images/default.png'"
          )
    v-row.justify-center
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.gray--text.mb-1 スタッフ名
        p.user-wrap__text
          | {{ staff.name }}
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.gray--text.mb-1 スタッフ名（ふりがな）
        p.user-wrap__text
          | {{ staff.name_kana }}
      v-col.col-sm-8.py-0(cols="12")
        p.text-subtitle-2.font-weight-bold.gray--text.mb-1 スタッフ紹介文
        p.user-wrap__text
          | {{ staff.body }}
</template>

<script>
export default {
  // middleware: "redirect",
  data() {
    return {
      staff: {
        name: "",
        name_kana: "",
        body: "",
        image: "",
      },
      image_name: "",
      image: false,
      staff_id: "",
    };
  },
  mounted() {
    this.staff.image = this.$store.getters.office.targetStaffImage;
    this.staff.name = this.$store.getters.office.targetStaff;
    this.staff.name_kana = this.$store.getters.office.targetStaffKana;
    this.staff.body = this.$store.getters.office.targetStaffBody;
  },
};
</script>
