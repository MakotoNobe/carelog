<template lang="pug">
v-card.pa-3(
  @click.stop="redirectoffice(office.id)",
  :ripple="false",
  :flat="isMobile",
  style="height: 388px"
)
  div
    span.web_note web予約可
  h3.mt-2.title.font-weight-bold 事業所名：{{ office.name }}
    span.icon
      //- v-icon(
      //-   small="",
      //-   @click.stop="toggleBookmark(office.id)",
      //-   :class="office.status && 'active'"
      //- ) mdi-star-outline
      v-icon(
        small="",
        @click.stop="toggleBookmark(office.id)",
        :class="office.status && 'active'"
      ) mdi-star
  v-row
    v-col(cols="auto")
      v-img.thumbnail(
        :src="(office && office.image && office.image.image) || '/images/no_image.png'",
        @error="office.image.image = '/images/no_image.png'",
        eager,
        :cover="true",
        width="120",
        height="120"
      )
    v-col.pl-0
      v-card-subtitle.pa-0
        span.info_item
          v-icon(small="") mdi-map-marker
          | {{ office.near_station }}
      v-card-subtitle.pa-0
        span.info_item
          v-icon(small="") mdi-account
          | スタッフ数{{ office.staff_number }}
      v-card-subtitle.pa-0
        span.info_item
          v-icon(small="") mdi-phone
          | {{ office.tel }}
  v-card-text.text-caption.gray--text.pa-0 {{ office.introduction }}
  v-row.v-info.accent-1.mt-3(:class="isMobile && 'py-1'")
    v-col.py-0(cols="auto")
      v-icon.pt-2(color="midgray") mdi-account
    v-col.pl-0.py-0
      .text-overline.text-left.pa-0.font-weight-bold.darkgray--text ユーザーからのお礼コメント
      .text-caption.pa-0.pb-2
        | {{ showThanksComment(office.having_staff) }}
  c-holiday.px-3(:holidays="holidays")
</template>
<script>
import Cookies from "js-cookie";
import CHoliday from "./c-holiday";
export default {
  name: "CCard",
  components: {
    CHoliday,
  },
  props: {
    office: {
      type: Object,
      required: false,
      default: () => {},
    },
    mark: {
      type: Boolean,
    },
    toggleBookmark: {
      type: Function,
      required: false,
      default: () => {},
    },
  },
  data() {
    return {};
  },
  computed: {
    showThanksComment() {
      const noMessage = "まだ口コミはありません。";
      return (value) => {
        if (value === "no" || value.thanks.length === 0) {
          return noMessage;
        } else {
          return value.thanks[0].body;
        }
      };
    },
    holidays() {
      return this.office.regular_holidays.map((day) => day.holiday);
    },
  },

  methods: {
    async redirectoffice(id) {
      const token = Cookies.get("user");
      if (token) {
        const url = "api/users/history";
        await this.$axios
          .post(url, {
            id,
          })
          .then(this.$router.push({ name: "offices-id", params: { id } }))
          .catch(this.$router.push({ name: "offices-id", params: { id } }));
      } else {
        this.$router.push({ name: "offices-id", params: { id } });
      }
    },
    // toggleBookmark(val){
    //   this.$emit("toggleBookmark", val)
    // }
    // async toggleBookmark(id) {
    //   const res = await this.$axios.post("/api/v1/users/bookmarks", {
    //     office_id: id,
    //   });
    //   console.log(res);
    // },
  },
};
</script>
<style lang="scss" scoped>
.geocode,
.areas,
.search-box {
  width: 100%;
}

.card_title {
  line-height: 1;
}

.web_note {
  background: #f0636433;
  color: #f06364;
  font-size: 11px;
  font-weight: bold;
  padding: 0 6px;
  border-radius: 2px;
  line-height: 19px;
}

.title {
  width: 100%;
  font-size: 18px !important;
  font-weight: bold;
  margin-top: 2px;
  position: relative;
}

.icon {
  position: absolute;
  right: 0;
  top: 50%;
  transform: translateY(-50%);
  background: #f5f7f7;
  height: 44px;
  width: 44px;
  line-height: 40px;
  text-align: center;
  border-radius: 50%;
  .v-icon {
    font-size: 25px !important;
    color: #d9dede;
    &:hover {
      color: #f09c3c;
    }
  }
  .active {
    color: #f09c3c;
  }
}

.introduction {
  line-height: 16px;
  font-size: 11px;
}

.subtitle {
  font-size: 10px !important;
}

.thank_comment {
  font-size: 11px;
}

.v-info {
  background: rgba(169, 240, 209, 0.16);
}

.info_item {
  font-size: 12px;
  i {
    padding-right: 2px;
    font-size: 12px !important;
  }
}
</style>
