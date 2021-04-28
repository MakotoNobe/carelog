<template lang="pug">
c-layout(center)
  .body-2.white.pa-4
    ValidationObserver(ref="obs", v-slot="{ invalid }")
      v-icon(color="staffcolor") mdi-chevron-left
      nuxt-link.text-decoration-none.staffcolor--text(:to="{ name: 'staffs' }") 事業所情報編集
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required",
        name="事業所名"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text
          | 事業所名
        v-text-field(
          type="text",
          autocomplete="name",
          placeholder="事業所",
          v-model="office.name",
          @focus="resetVilidMessage",
          single-line,
          outlined,
          flat,
          solo,
          style="max-width: 343px",
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required|tel",
        name="電話番号"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text 電話番号
        v-text-field.ml-1.mt-0(
          type="tel",
          autocomplete="tel",
          placeholder="08012345678",
          v-model="office.tel",
          maxlength="13",
          @input="telWatch",
          outlined,
          flat,
          solo,
          @focus="resetVilidMessage",
          single-line,
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required|tel",
        name="fax"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text
          | FAX
        v-text-field.ml-1.mt-0(
          type="tel",
          autocomplete="tel",
          placeholder="08012345678",
          maxlength="13",
          v-model="office.fax",
          @focus="resetVilidMessage",
          @input="faxWatch",
          single-line,
          outlined,
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required|postalCode",
        name="郵便番号"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text
          | 住所
        v-row.d-flex.align_item_center.mb-2.gray--text
          v-col.py-0(cols="auto")
            span 〒
          v-col.py-0.pl-0
            v-text-field.ml-1.mt-0(
              type="postal-code",
              name="postal-code",
              @blur="searchAddress",
              placeholder="0000000",
              v-model="office.postcode",
              @focus="resetVilidMessage",
              single-line,
              outlined,
              style="max-width: 107px",
              hide-details
            )
            span.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        rules="required",
        name="住所"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text
        v-text-field.ml-1.mt-0(
          type="text",
          name="address",
          :placeholder="placeholder",
          v-model="office.address",
          @focus="resetVilidMessage",
          single-line,
          outlined,
          hide-details
        )
        p.primary--text.text-body-2 {{ errors[0] }}
      ValidationProvider(
        v-slot="{ errors, classes }",
        mode="lazy",
        rules="required",
        name="最寄り駅"
      )
        v-card-subtitle.body-1.font-weight-bold.gray--text
          | 最寄り駅
        v-text-field.ml-1.mt-0(
          type="text",
          autocomplete="name",
          placeholder="新宿駅徒歩5分",
          v-model="office.near_station",
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
        name="スタッフ数"
      )
        v-card-subtitle#dropdown-age.body-1.font-weight-bold.gray--text スタッフ数
        v-card(max-width="168", flat)
          v-select(
            v-model="office.staff_number",
            :items="nums",
            :placeholder="office.staff_number",
            @focus="resetVilidMessage",
            target="#dropdown-age",
            outlined,
            hide-details
          )
            template(v-slot:selection="{ item }")
              span.darkgray--text.font-weight-regular {{ item }}人
          p.primary--text.text-body-2 {{ errors[0] }}
      v-card-subtitle.body-1.font-weight-bold.gray--text
        | 経営・事業主体
      v-text-field.ml-1.mt-0(
        type="text",
        autocomplete="name",
        v-model="office.company",
        single-line,
        outlined,
        style="max-width: 343px",
        hide-details
      )
      p.primary--text.text-body-2
      v-card-subtitle.body-1.font-weight-bold.gray--text
        | サイトURL
      v-text-field.ml-1.mt-0(
        type="text",
        autocomplete="name",
        v-model="office.url",
        single-line,
        outlined,
        style="max-width: 343px"
      )
      v-card-subtitle.body-1.font-weight-bold.gray--text 特徴タイトル
      v-text-field.ml-1(v-model="office.title", outlined, flat, solo)
      v-card-subtitle.body-1.font-weight-bold.gray--text 特徴詳細
      v-textarea.ml-1(v-model="office.introduction", outlined, flat)
      v-card-subtitle.body-1.font-weight-bold.gray--text メイン画像
      v-btn.subtitle-2.px-0(
        text,
        color="staffcolor",
        @click="openTopImage",
        small
      ) 画像アップロード
      v-card.pa-3(flat)
        input.d-none(
          type="file",
          @change="setImageTops($event)",
          multiple,
          label="メイン画像",
          ref="refImageTop"
        )
        draggable(
          :options="options",
          v-model="office.main_image",
          group="top_image_group"
        )
          v-img(
            v-if="office.main_image[0].image == null",
            src="/images/no_image.png",
            style="height: 150px; width: 716px"
          )
          v-img(
            v-else,
            :src="office.main_image[0].image",
            style="height: 150px; width: 716px"
          )
          .text-right(align-self="end")
            v-text-field.mt-0(
              v-model="office.main_image[0].text",
              outlined,
              flat,
              solo="",
              placeholder="画像のコメントがあれば、ご記入ください"
            )
      v-card(flat)
        draggable.d-flex.flex-wrap(
          :options="options",
          v-model="office.top_images",
          group="top_image_group"
        )
          v-col(
            v-for="(top_image, index) in office.top_images",
            :key="index",
            cols="12",
            md="6"
          )
            v-img(
              v-if="top_image.image == null",
              src="/images/no_image.png",
              style="height: 75px; width: 358px"
            )
            v-img(
              v-else,
              :src="top_image.image",
              style="height: 75px; width: 358px"
            )
            v-text-field(
              v-model="top_image.text",
              solo="",
              outlined,
              flat,
              placeholder="画像のコメント"
            )
      v-card(flat)
        v-card-subtitle.body-1.font-weight-bold.gray--text 左の画像
        v-btn.subtitle-2.px-0(
          text,
          color="staffcolor",
          @click="openLeftImage",
          small
        ) 画像アップロード
        input.d-none(
          type="file",
          @change="setImageLeft($event)",
          label="左の画像",
          multiple,
          ref="refImageLeft"
        )
        v-img(
          v-if="office.left_image.image == null",
          src="/images/no_image.png",
          style="height: 150px; width: 716px"
        )
        v-img(
          v-else,
          :src="office.left_image.image",
          style="height: 150px; width: 716px"
        )
        .text-right(align-self="end")
          v-textarea.ml-1.mt-0(
            v-model="office.left_image.text",
            solo="",
            outlined,
            flat,
            placeholder="画像のコメントがあれば、ご記入ください"
          )
        v-card-subtitle.body-1.font-weight-bold.gray--text 右の画像
        v-btn.subtitle-2.px-0(
          text,
          color="staffcolor",
          @click="openRightImage",
          small
        ) 画像アップロード
        input.d-none(
          type="file",
          @change="setImageRight($event)",
          label="右の画像",
          ref="refImageRight",
          multiple
        )
        v-img(
          v-if="office.right_image.image == null",
          src="/images/no_image.png",
          style="height: 150px; width: 716px"
        )
        v-img(
          v-else,
          :src="office.right_image.image",
          type="submit",
          style="height: 150px; width: 716px"
        )
        .text-right(align-self="end")
          v-textarea.ml-1.mt-0(
            v-model="office.right_image.text",
            solo="",
            outlined,
            flat,
            placeholder="画像のコメントがあれば、ご記入ください"
          )
        v-card-subtitle.body-1.font-weight-bold.gray--text 定休日を選択してください
      v-row
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="月曜",
            color="warning",
            value="mon"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="火曜",
            color="warning",
            value="tue"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="水曜",
            color="warning",
            value="wed"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="木曜",
            color="warning",
            value="thu"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="金曜",
            color="warning",
            value="fri"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="土曜",
            color="warning",
            value="sut"
          )
        v-col(cols="3")
          v-checkbox.mt-0(
            v-model="regular_holidays",
            label="日曜",
            color="warning",
            value="sun"
          )
      v-container.pa-0.pl-1
        v-btn.font-weight-bold(
          :x-large="!isMobile",
          :large="isMobile",
          @click="editoffice",
          color="staffcolor",
          depressed,
          block,
          darkgray,
          :disabled="invalid"
        ) 変更する
    v-container.subtitle-2.text-center
      nuxt-link.text-decoration-none.staffcolor--text(to="/offices") もどる
</template>

<script>
import draggable from "vuedraggable";
import { AsYouType } from "libphonenumber-js";

const maxNum = 120;
const minNum = 1;
const numRange = [...Array(maxNum - minNum + 1).keys()].map(
  (item) => item + minNum
);

export default {
  middleware: "match-office-id",
  components: {
    draggable,
  },
  data() {
    return {
      options: {
        group: "top_image_group",
        animation: 200,
      },
      office: {
        name: "",
        tel: "",
        fax: "",
        postcode: "",
        address: "",
        near_station: "",
        staff_number: "",
        company: "",
        url: "",
        title: "",
        introduction: "",
        main_image: [{ id: "", image: "", text: "" }],
        top_images: [
          { id: "", image: "", text: "" },
          { id: "", image: "", text: "" },
          { id: "", image: "", text: "" },
          { id: "", image: "", text: "" },
        ],
        left_image: { id: "", image: "", text: "" },
        right_image: { id: "", image: "", text: "" },
      },
      defaultTopImageNumber: [],
      regular_holidays: [],
      errorMessages: [],
      addresses: {
        zipcode: "",
        addressData: {},
      },
      placeholder: "東京都世田谷区祖師谷4-3-15",
      formFocus: false,
      nums: numRange,
    };
  },
  watch: {
    office: {
      handler() {
        if (this.office.main_image.length === 2) {
          // サブ画像がメイン画像にきた時
          const expandImage = this.office.main_image[1];
          this.office.main_image.pop();
          this.office.top_images.unshift(expandImage);
        } else if (this.office.main_image.length === 0) {
          // メイン画像がサブ画像にいく時
          const expandImage = this.office.top_images[0];
          this.office.top_images.shift();
          this.office.main_image.push(expandImage);
        }
      },
      deep: true,
    },
  },
  async mounted() {
    const res = await this.$axios.$get(`/api/offices/${this.$route.params.id}`);
    this.office.name = res.name;
    this.office.tel = res.tel;
    this.office.fax = res.fax;
    this.office.postcode = res.postcode;
    this.office.address = res.address;
    this.office.near_station = res.near_station;
    this.office.staff_number = res.staff_number;
    this.office.company = res.company;
    this.office.url = res.url;
    this.office.title = res.title;
    this.office.introduction = res.introduction;
    // 曜日挿入
    const regularHolidays = [];
    res.regular_holidays.forEach((day) => regularHolidays.push(day.holiday));
    this.regular_holidays = regularHolidays;
    // トップメイン画像保存
    this.office.main_image[0].id = res.top_images[0].id;
    this.office.main_image[0].image = res.top_images[0].image;
    this.office.main_image[0].text = res.top_images[0].text;
    // トップサブ画像保存
    for (let i = 0; i <= 3; i++) {
      const id = i + 1;
      this.office.top_images[i].id = res.top_images[id].id;
      this.office.top_images[i].image = res.top_images[id].image;
      this.office.top_images[i].text = res.top_images[id].text;
    }
    // デフォルトナンバー付与
    const defaultTopImageNumber = [];
    res.top_images.forEach((t) => defaultTopImageNumber.push(t.id));
    this.defaultTopImageNumber = defaultTopImageNumber;
    // 左右画像保存
    this.office.left_image.id = res.left_image.id;
    this.office.left_image.image = res.left_image.image;
    this.office.left_image.text = res.left_image.text;
    this.office.right_image.id = res.right_image.id;
    this.office.right_image.image = res.right_image.image;
    this.office.right_image.text = res.right_image.text;
    for (let i = 1; i <= 100; i++) {
      this.nums.push(i);
    }
  },
  methods: {
    async editoffice() {
      const holidays = [];
      this.regular_holidays.forEach((day) =>
        holidays.push({
          holiday: `${day}`,
        })
      );
      await this.$axios.put(`/api/offices/edit`, {
        office: {
          name: this.office.name,
          tel: this.office.tel,
          fax: this.office.fax,
          postcode: this.office.postcode,
          address: this.office.address,
          near_station: this.office.near_station,
          staff_number: this.office.staff_number,
          company: this.office.company,
          url: this.office.url,
          title: this.office.title,
          introduction: this.office.introduction,
          holiday: holidays,
          top: [
            {
              id: this.defaultTopImageNumber[0],
              text: this.office.main_image[0].text,
              image: this.office.main_image[0].image,
              position: "top",
            },
            {
              id: this.defaultTopImageNumber[1],
              text: this.office.top_images[0].text,
              image: this.office.top_images[0].image,
              position: "top",
            },
            {
              id: this.defaultTopImageNumber[2],
              text: this.office.top_images[1].text,
              image: this.office.top_images[1].image,
              position: "top",
            },
            {
              id: this.defaultTopImageNumber[3],
              text: this.office.top_images[2].text,
              image: this.office.top_images[2].image,
              position: "top",
            },
            {
              id: this.defaultTopImageNumber[4].id,
              text: this.office.top_images[3].text,
              image: this.office.top_images[3].image,
              position: "top",
            },
          ],
          left: {
            text: this.office.left_image.text,
            id: this.office.left_image.id,
            image: this.office.left_image.image,
            position: "left",
          },
          right: {
            text: this.office.right_image.text,
            id: this.office.right_image.id,
            image: this.office.right_image.image,
            position: "right",
          },
        },
      });
      this.$router.push("/offices/");
    },
    setImageTops(e) {
      const file = e.target.files[0] || e.dataTransfer.files;
      const allowExts = ["image/jpg", "image/jpeg", "image/png", "image/gif"];
      if (allowExts.find((ext) => ext === file.type) !== undefined) {
        const reader = new FileReader();
        reader.onload = (e) => {
          if (this.office.main_image[0].image === null) {
            this.office.main_image[0].image = e.target.result;
          } else if (this.office.top_images[0].image === null) {
            this.office.top_images[0].image = e.target.result;
          } else if (this.office.top_images[1].image === null) {
            this.office.top_images[1].image = e.target.result;
          } else if (this.office.top_images[2].image === null) {
            this.office.top_images[2].image = e.target.result;
          } else {
            this.office.top_images[3].image = e.target.result;
          }
        };
        reader.readAsDataURL(file);
      } else {
        alert(
          ".jpg、.jpeg, .gif、.pngのいずれかのファイルのみ許可されています\n"
        );
      }
    },
    setImageLeft(e) {
      const file = e.target.files[0] || e.dataTransfer.files;
      const allowExts = ["image/jpg", "image/jpeg", "image/png", "image/gif"];
      if (allowExts.find((ext) => ext === file.type) !== undefined) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.office.left_image.image = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        alert(
          ".jpg、.jpeg, .gif、.pngのいずれかのファイルのみ許可されています\n"
        );
      }
    },
    setImageRight(e) {
      const file = e.target.files[0] || e.dataTransfer.files;
      const allowExts = ["image/jpg", "image/jpeg", "image/png", "image/gif"];
      if (allowExts.find((ext) => ext === file.type) !== undefined) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.office.right_image.image = e.target.result;
        };
        reader.readAsDataURL(file);
      } else {
        alert(
          ".jpg、.jpeg, .gif、.pngのいずれかのファイルのみ許可されています\n"
        );
      }
    },
    openTopImage() {
      this.$refs.refImageTop.click();
    },

    openLeftImage() {
      this.$refs.refImageLeft.click();
    },

    openRightImage() {
      this.$refs.refImageRight.click();
    },

    async searchAddress() {
      this.placeholder = "";
      await this.$axios
        .$get(`/postcode/search?zipcode=${this.office.postcode}`)
        .then((res) => {
          if (res.results === null && res.message === null) {
            return (this.placeholder =
              "該当の郵便番号が見つかりませんでした。");
          } else if (res.status === 400) {
            return (this.placeholder = "郵便番号の桁数が不正です。");
          } else {
            const result = res.results[0];
            return (this.office.address = `${result.address1}${result.address2}${result.address3}`);
          }
        });
    },
    resetVilidMessage() {
      this.errorMessages = [];
    },
    telWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.office.tel)) {
        // 整形する関数
        const formatTel = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatTel(this.office.tel);
        this.office.tel = formatedPhoneNumber;
      }
    },
    faxWatch() {
      const regex = RegExp("[0-9]{9,11}");
      if (regex.test(this.office.fax)) {
        // 整形する関数
        const formatfax = function (val) {
          return new AsYouType("JP").input(val);
        };
        // 有効な番号の場合整形
        const formatedPhoneNumber = formatfax(this.office.fax);
        this.office.fax = formatedPhoneNumber;
      }
    },
  },
};
</script>
