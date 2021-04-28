<template lang="pug">
  c-layout(center)
    v-dialog(v-model="dialog"  max-width="300px")
      template(v-slot:activator="{ on, attrs }")
        div.pa-3.mt-4
          h1.darkgray--text(:class="!isMobile &&'text-h3 mb-4'||'text-h4 mb-0'") スタッフ情報
          v-row
            v-col(v-for="(staff, index) in staffs", :key="index", cols="12" md="6")
              v-card(flat)
                v-row
                  v-col.mb-0(cols="auto")
                    v-avatar.mt-0.mb-1.ml-4(size="80")
                      v-img(
                        :src="staff.image ||'/images/default.png'",
                        @error="staff.image ='/images/default.png'"
                      )
                  v-col.pl-0.pr-5
                    p.text-subtitle-2.font-weight-bold.darkgray--text.mt-0.mb-0 {{ staff.name }}
                    p.text-overline.mb-2.pa-0.mt-0.gray--text {{ staff.name_kana }}
                    p.text-body-2.mt-0.gray--text {{ staff.body }}
                c-row.pa-4(xsmall)
                  v-col(cols="5")
                    v-btn.staffcolor--text(
                      text,
                      v-bind="attrs",
                      v-on="on",
                      @click="deleteId = index"
                      outlined
                      depressed
                      block
                    ) 削除
                  v-col(cols="7")
                    v-btn(
                      color="staffcolor",
                      @click="editstaff(staff.id)"
                      depressed
                      block
                      dark
                    ) 編集する
          v-row
            v-col
              v-card(flat)
                v-btn(
                  @click="newStaff",
                  text,
                  block
                  depressed
                  dark
                  large
                )
                  span.staffcolor--text.font-weight-bold
                    v-icon mdi-plus
                    | スタッフを追加する
      v-card
        v-container
          v-card-text.text-center 削除しますか？
          v-row
            v-col(cols="5").mr-5
              v-btn(
                text="",
                color="warning",
                elevation="2",
                @click="dialog = false"
              ) キャンセル
            v-col(align-self="end")
              v-btn(
                color="warning",
                @click="deletestaff()"
              ) 削除する
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      staffs: [],
      deleteId: "",
    };
  },
  async mounted() {
    const res = await this.$axios.get("/api/staffs");
    // console.log(res.data[0].staff.office.office_images[0].image);
    this.staffs = res.data;
  },
  methods: {
    async deletestaff() {
      const index = this.deleteId;
      await this.$axios.delete(`/api/staffs?staff_id=${this.staffs[index].id}`);
      this.staffs.splice(index, 1);
      this.deleteId = "";
      this.dialog = false;
    },
    editstaff(id) {
      this.$router.push({ name: "staffs-edit-id", params: { id } });
    },
    newStaff() {
      this.$router.push({ name: "staffs-new" });
    },
  },
};
</script>
