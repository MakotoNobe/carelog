<template lang="pug">
c-layout(center)
  v-dialog(
    v-model="dialog",
    max-width="300px",
    overlay-color="darkgray",
    :overlay-opacity="0.8"
  )
    template(v-slot:activator="{ on, attrs }")
      .px-3(:class="{ 'mt-4': isMobile }")
        h1.text-h3.font-weight-bold.mb-2 利用者情報管理
        c-row(small)
          v-col(
            v-for="(patient, index) in patients",
            :key="index",
            cols="12",
            md="6"
          )
            v-card.pa-3.mb-3
              v-row
                v-col.pt-0(cols="auto")
                  v-avatar(size="80px")
                    v-img(
                      :src="patient.image || '/images/default.png'",
                      @error="patient.image = '/images/default.png'"
                    )
                v-col.pt-0
                  p.subtitle-1.font-weight-bold.mb-0 {{ patient.name }} ({{ patient.age }})
                  p.gray--text.overline.mb-0(style="line-height:12px") {{ patient.name_kana }}
                  .my-2
                    p.body-2.mb-0.gray--text 〒{{ patient.postcode }}
                    p.body-2.mb-0.gray--text {{ patient.address }}
                  p.body-2.body-1.mb-0.gray--text 家族構成：{{ patient.family }}
                v-col.py-0(cols="12")
                  p.body-2.font-weight-bold.mb-0.gray--text 担当スタッフ：{{ patient.staff.name }}
                v-col.pb-0(cols="4")
                  v-btn.px-9(
                    outlined,
                    color="warning",
                    text="",
                    v-bind="attrs",
                    v-on="on",
                    @click="deleteId = index"
                  ) 削除
                v-col.pb-0(cols="8")
                  v-btn(
                    block,
                    depressed,
                    color="warning",
                    @click="editpatient(patient.id)"
                  ) 編集する
        v-row
          v-col(cols="12")
            v-card(flat)
              v-btn(
                depressed,
                :x-large="!isMobile",
                :large="isMobile",
                block,
                outlined,
                @click="newpatient",
                color="warning",
                text
              )
                v-icon.mr-2(size="30") mdi-plus
                span.font-weight-bold.text-h5
                  | 利用者を追加する
    v-card
      v-card-text.pt-10.pb-4.text-h6.text-center 削除しますか？
      v-row
        v-col(cols="5")
          v-btn(
            outlined,
            color="bluegray",
            depressed,
            block,
            @click="dialog = false"
          )
            span.text-subtitle-2.font-weight-bold.staffcolor--text キャンセル
        v-col(cols="7")
          v-btn(
            dark,
            color="staffcolor",
            block,
            depressed,
            @click="deletepatient()"
          )
            span.text-subtitle-2.font-weight-bold 削除する
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      patients: [],
      deleteId: "",
    };
  },
  async mounted() {
    const res = await this.$axios.get("/api/v1/patients");
    this.patients = res.data;
  },
  methods: {
    async deletepatient() {
      const index = this.deleteId;
      await this.$axios.delete(
        `/api/patients?patient_id=${this.patients[index].id}`
      );
      this.patients.splice(index, 1);
      this.deleteId = "";
      this.dialog = false;
    },
    editpatient(id) {
      this.$router.push({ name: "patients-edit-id", params: { id } });
    },
    newpatient() {
      this.$router.push({ name: "patients-new" });
    },
  },
};
</script>
