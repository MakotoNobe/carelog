<template lang="pug">
c-layout(center)
  p.pa-0(v-if="!isMobile")
    span
      v-icon(text, color="staffcolor") mdi-chevron-left
    nuxt-link.staffcolor--text.text-decoration-none.text-body-2(to="/patients") 利用者一覧にもどる
  .white.pa-2(:class="(isMobile && 'mt-3') || ''")
    v-card-title.ml-1.font-weight-bold.darkgray--text.text-h3(
      :class="(!isMobile && 'text-h3') || 'text-h4'"
    ) 利用者情報編集
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      v-row
        v-col(cols="auto")
          v-avatar.ml-4(size="120")
            v-img(
              :src="patient.image || '/images/default.png'",
              @error="patient.image = '/images/default.png'"
            )
        v-col(align-self="end")
          v-btn.subtitle-2.px-0.text-subtitle-2(
            text,
            color="staffcolor",
            @click="openImage",
            small
          ) 画像をアップロードする
          input.d-none(
            type="file",
            @change="imageUp($event)",
            multiple,
            label="利用者画像",
            ref="input"
          )
      .pa-4
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="利用者名"
        )
          p.font-weight-bold.gray--text.text-body-1.mb-1 利用者名
          v-text-field(
            v-model="patient.name",
            outlined,
            @focus="resetVilidMessage",
            hide-details
          )
          p.primary--text.text-body-2 {{ errors[0] }}
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="ふりがな"
        )
          p.font-weight-bold.gray--text.text-body-1.mb-1 利用者名（ふりがな）
          v-text-field(
            v-model="patient.name_kana",
            outlined,
            @focus="resetVilidMessage",
            hide-details
          )
          p.primary--text.text-body-2 {{ errors[0] }}

        //- 年齢セレクト
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="年齢"
        )
          p#dropdown-age.font-weight-bold.gray--text.text-body-1.mb-1 利用者の年齢
          v-select(
            v-model="patient.age",
            :items="ages",
            :placeholder="patient.age",
            outlined,
            target="#dropdown-age",
            style="width: 200px",
            @focus="resetVilidMessage",
            hide-details
          )
            template(v-slot:selection="{ item }")
              span.darkgray--text.font-weight-regular {{ item }}歳
          p.primary--text.text-body-2 {{ errors[0] }}
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required|postalCode",
          name="郵便番号"
        )
          p.mb-0.font-weight-bold.gray--text.text-body-1 利用者住所
          v-row.pa-3.pb-0
            p.font-weight-bold.gray--text.text-body-1.pa-2.pl-0.mb-0 〒
            div
              v-text-field(
                v-model="patient.postcode",
                hide-details,
                outlined,
                placeholder="0000000",
                style="width: 100px",
                type="postal-code",
                name="postal-code",
                @blur="searchAddress",
                @focus="resetVilidMessage"
              )
              span.primary--text.text-body-2 {{ errors[0] }}
          ValidationProvider(
            v-slot="{ errors, classes }",
            rules="required",
            name="住所"
          )
            v-text-field.mt-2(
              name="address",
              v-model="patient.address",
              outlined,
              :placeholder="placeholder",
              @focus="resetVilidMessage",
              hide-details
            )
            p.primary--text.text-body-2 {{ errors[0] }}
        p.font-weight-bold.gray--text.text-body-1.mb-1 家族構成
        v-textarea(v-model="patient.family", outlined)

        //- 担当スタッフ
        ValidationProvider(
          v-slot="{ errors, classes }",
          mode="lazy",
          rules="required",
          name="担当スタッフ"
        )
          p#dropdown-staff.font-weight-bold.gray--text.text-body-1.mb-1 担当スタッフ
          v-select(
            v-model="patient.staff.name",
            :items="patient_staffs",
            :placeholder="patient.staff.name",
            outlined,
            target="#dropdown-staff",
            @focus="resetVilidMessage"
          )
          p.primary--text.text-body-2.mb-10 {{ errors[0] }}
        v-container.pa-0
          v-btn(
            :x-large="!isMobile",
            :large="isMobile",
            color="staffcolor",
            @click="editpatient",
            darkgray,
            block,
            depressed,
            :disabled="invalid"
          ) 変更する
        v-container.text-center
          nuxt-link.text-decoration-none.staffcolor--text(to="/patients") もどる
</template>

<script>
export default {
  async asyncData(context) {
    const resPatient = await context.$axios.$get("/api/v1/patients");
    const targetPatient = await resPatient.find(
      (patient) => patient.id === context.params.id
    );
    const resStaff = await context.$axios.$get("/api/v1/staffs");
    const targetStaffs = resStaff.map((staff) => staff.name);
    return {
      patient: targetPatient,
      patient_staffs: targetStaffs,
    };
  },
  data() {
    return {
      patient: {},
      patient_staffs: [],
      ages: [],
      placeholder: "東京都世田谷区祖師谷4-3-15",
      errorMessages: [],
      formFocus: false,
    };
  },
  mounted() {
    // 年齢データ挿入
    for (let i = 1; i <= 100; i++) {
      this.ages.push(i);
    }
  },
  methods: {
    async editpatient() {
      await this.$axios.put(
        `/api/patients?patient_id=${this.$route.params.id}`,
        {
          patients: {
            name: this.patient.name,
            name_kana: this.patient.name_kana,
            age: this.patient.age,
            postcode: this.patient.postcode,
            address: this.patient.address,
            family: this.patient.family,
            staff: this.patient.staff,
            image: this.patient.image,
          },
        }
      );
      this.$router.push("/patients");
    },
    imageUp(e) {
      const file = e.target.files[0] || e.dataTransfer.files;
      const allowExts = ["image/jpg", "image/jpeg", "image/png", "image/gif"];
      if (allowExts.find((ext) => ext === file.type) !== undefined) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.patient.image = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        alert(
          ".jpg、.jpeg, .gif、.pngのいずれかのファイルのみ許可されています\n"
        );
      }
    },
    openImage() {
      this.$refs.input.click();
    },
    async searchAddress() {
      this.placeholder = "";
      await this.$axios
        .$get(`/postcode/search?zipcode=${this.patient.postcode}`)
        .then((res) => {
          if (res.results === null && res.message === null) {
            return (this.placeholder =
              "該当の郵便番号が見つかりませんでした。");
          } else if (res.status === 400) {
            return (this.placeholder = "郵便番号の桁数が不正です。");
          } else {
            const result = res.results[0];
            return (this.patient.address = `${result.address1}${result.address2}${result.address3}`);
          }
        });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
  },
};
</script>
