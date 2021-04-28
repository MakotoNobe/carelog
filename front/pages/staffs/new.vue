<template lang="pug">
c-layout(center)
  p.body-2(v-if="!isMobile")
    v-icon(color="staffcolor") mdi-chevron-left
    nuxt-link.text-decoration-none.staffcolor--text(:to="{ name: 'staffs' }") スタッフ情報一覧にもどる
  .white.pa-4(:class="{ 'mt-3': isMobile }")
    v-card-title.pa-0.font-weight.darkgray--text.text-h3(
      :class="{ 'mb-3': isMobile }"
    ) スタッフ情報入力
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      v-row
        v-col(cols="auto")
          v-avatar(size="120")
            v-img(
              :src="staff_image || '/images/default.png'",
              @error="staff_image = '/images/default.png'"
            )
        v-col(align-self="end", :class="{ 'text-right': isMobile }")
          v-btn.subtitle-2.px-0(
            text,
            color="staffcolor",
            @click="openImage",
            small
          ) 画像をアップロードする
          input.d-none(
            type="file",
            @change="imageUp($event)",
            multiple,
            label="スタッフ画像",
            ref="input"
          )
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required",
        name="スタッフ名"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text スタッフ名
        v-text-field.ml-1.mt-0(
          v-model="staff_name",
          outlined,
          flat,
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
        v-card-subtitle.body-1.font-weight-bold.gray--text スタッフ名（ふりがな）
        v-text-field.ml-1(
          v-model="staff_name_kana",
          outlined,
          flat,
          @focus="resetVilidMessage",
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      v-card-subtitle.body-1.font-weight-bold.gray--text スタッフ紹介文
      v-textarea.ml-1(v-model="staff_body", outlined, flat)
      v-container.pa-0.pl-1
        v-btn.font-weight-bold(
          :x-large="!isMobile",
          :large="isMobile",
          @click="newStaff",
          color="staffcolor",
          depressed,
          block,
          darkgray,
          :disabled="invalid"
        )
          | 追加する
    v-container.subtitle-2.text-center
      nuxt-link.text-decoration-none.staffcolor--text(to="/staffs") もどる
</template>

<script>
export default {
  data() {
    return {
      staff: {},
      staff_name: "",
      staff_name_kana: "",
      staff_body: "",
      staff_image: "",
      formFocus: false,
      errorMessages: [],
    };
  },
  methods: {
    async newStaff() {
      await this.$axios.post(`/api/staffs`, {
        staff: {
          name: this.staff_name,
          name_kana: this.staff_name_kana,
          body: this.staff_body,
          image: this.staff_image,
        },
      });
      this.$router.push("/staffs");
    },
    imageUp(e) {
      const file = e.target.files[0] || e.dataTransfer.files;
      const allowExts = ["image/jpg", "image/jpeg", "image/png", "image/gif"];
      if (allowExts.find((ext) => ext === file.type) !== undefined) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.staff_image = e.target.result;
          console.log(this.staff_image);
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
    resetVilidMessage() {
      this.errorMessages = [];
    },
  },
};
</script>
