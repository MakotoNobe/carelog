<template lang="pug">
c-layout
  v-row(:class="{ 'flex-column-reverse': isMobile }")
    v-col(cols="12", md="7")
      v-card.overflow-hidden(v-if="!isMobile")
        v-row.white(v-if="hasImages")
          v-col.py-0(cols="12", style="position: relative")
            v-carousel(v-model="slideCurrent", height="322", hide-delimiters)
              v-card(min-height="322", flat)
                v-carousel-item(
                  v-for="(image, index) in office.top_images",
                  :key="index",
                  :src="image.image",
                  :value="index",
                  reserve-transition="fade-transition",
                  transition="fade-transition"
                )
            .text-center.white--text.text-body-2.py-3.carousel-delimiters {{ slideCurrent + 1 }} / {{ office.top_images.length }}
          v-col.py-0(cols="12")
            .images__grid.pa-4
              v-card(
                v-for="(image, index) in office.top_images",
                :key="image.id",
                :class="{ active: index === slideCurrent }",
                dark,
                height="69",
                @click.stop="slideCurrent = index",
                tile
              )
                v-img(:src="image.image", width="100%")
        v-row.white(v-else)
          v-img(min-height="322", src="/images/no_image.png")
      v-card.pa-4(:class="{ 'mt-6': !isMobile }", :flat="isMobile")
        .mb-5.font-weight-bold.darkgray--text(
          :class="{ 'text-h3': !isMobile, 'text-h5': isMobile }"
        ) {{ office.name }}
        .subtitle-2.font-weight-regular.gray--text {{ office.introduction }}
        .images_detail__grid.mt-5
          v-card(v-for="(image, index) in imageDetails", :key="index", flat)
            div(:style="{ height: (isMobile ? 120 : 180) + 'px' }")
              v-img(
                :src="image.src",
                width="100%",
                :height="isMobile ? 120 : 180"
              )
            .text-body-2.font-weight-regular.gray--text.mt-2 {{ image.title }}
      v-card.mt-6.pa-4(:flat="isMobile", :class="{ 'pb-0': !showStaff }")
        v-card-title.pa-0
          .font-weight-bold(
            :class="{ 'text-h3': !isMobile, 'text-h5': isMobile }"
          ) スタッフ紹介
          v-spacer
          v-btn(text, color="primary", @click="postThank()")
            span.text-subtitle-2 お礼を投稿する
        v-row(
          v-for="(staff, index) in staffs",
          :key="index + '-staff'",
          v-show="(!showStaff && index<=3) || showStaff ",
          v-if="staff.thank.length !== 0"
        )
          v-col(cols="auto")
            v-avatar(size="80")
              v-img(
                v-if="staff.image",
                :src="staff.image || '/images/default.png'",
                @error="staff.image = '/images/default.png'"
              )
          v-col.pt-0
            v-row
              v-col.pt-1(cols="auto")
                .text-h6.font-weight-bold.darkgray--text {{ staff.name }}
                .text-body-2.font-weight-regular.gray--text {{ staff.name_kana }}
              v-col
                .text-body-2.font-weight-regular.gray--text {{ staff.body }}
            c-comment(
              v-if="!isMobile",
              :staffs="staffs",
              :staff="staff",
              @toggleThanks="toggleThanks(index, $event)"
            )
          v-col.pt-0(v-if="isMobile", cols="12")
            c-comment(
              :staffs="staffs",
              :staff="staff",
              @toggleThanks="toggleThanks(index, $event)"
            )
        //- お礼投稿ない場合の表示
        v-row(v-else)
        v-card(
          v-if="!showStaff",
          flat,
          height="140",
          width="100%",
          style="position: absolute; bottom: 0; left: 0",
          color="transparent"
        )
          v-img(
            gradient="rgba(255,255,255,0),rgba(255,255,255,1) 30%",
            height="100%"
          )
            v-row.fill-height(align="center", justify="center")
              v-col.text-center
                v-btn(
                  color="primary",
                  text,
                  block,
                  @click.stop="showStaff = true"
                )
                  span.text-subtitle-2.font-bold-regular もっと見る
                  v-icon(color="primary") mdi-chevron-down
      v-card.mt-6.pa-4(:flat="isMobile")
        .font-weight-bold.darkgray--text(
          :class="{ 'text-h3': !isMobile, 'text-h5': isMobile }"
        ) 施設概要

        v-simple-table
          template(v-slot:default)
            tbody
              tr
                td.text-body-2.font-weight-bold.gray--text 住所
                td.text-subtitle-2.font-weight-regular.darkgray--text
                  div 〒{{ office.postcode }}
                  div {{ office.address }}
              tr
                td.text-body-2.font-weight-bold.gray--text 経営・事業主体
                td.text-subtitle-2.font-weight-regular.darkgray--text {{ office.company }}
              tr
                td.text-body-2.font-weight-bold.gray--text 公式サイト
                td.text-subtitle-2.font-weight-regular.darkgray--text
                  a.text-decoration-none(:href="office.url", taget="_blank") {{ office.url }}

    v-col(
      cols="12",
      md="5",
      style="position: sticky; top: 28px; height: 100px",
      :class="{ 'pt-0': isMobile }"
    )
      v-card.pa-4(:flat="isMobile")
        .darkgray---text.d-flex(
          :class="{ 'text-h1 mb-3': !isMobile, 'text-h3 mb-2': isMobile }"
        )
          span {{ office.name }}
          v-spacer
          v-avatar(size="44", color="#F5F7F7")
            v-icon(
              color="#F09C3C",
              @click="toggleBookmark(office.id)",
              :class="'active'"
            ) mdi-star
        .body-1.gray--text 〒{{ office.postcode }}
        .body-1.gray--text.mb-4 {{ office.address }}
        v-row.darkgray--text
          v-col.mb-4.py-0(cols="auto")
            v-icon.mr-2(color="midgray") mdi-map-marker
            | {{ office.near_station }}
          v-col.py-0
            div(style="min-width: 100px")
              v-icon.mr-2(color="midgray") mdi-account
              | スタッフ数{{ office.staff_number }}人
        v-row.darkgray--text
          v-col.py-0(:cols="isMobile ? 'auto' : 12")
            v-icon.mr-3(color="midgray", :size="isMobile ? 20 : 32") mdi-phone
            span.font-weight-bold(
              :class="{ 'text-h2': !isMobile, 'text-h5': isMobile }"
            ) {{ office.tel }}
          v-col.py-0(:cols="isMobile ? undefined : 12")
            span.font-weight-bold.midgray--text.mr-3(
              :class="{ 'text-h4': !isMobile, 'text-h6': isMobile }"
            ) FAX
            span.font-weight-bold(
              :class="{ 'text-h2': !isMobile, 'text-h5': isMobile }"
            ) {{ office.fax }}
          v-col.py-0(cols="12")
            v-btn.mt-6.mb-4(
              color="primary",
              @click="postReserve",
              :x-large="!isMobile",
              :large="isMobile",
              depressed,
              block
            ) Web予約する
          v-col.py-0(cols="12")
            c-holiday.px-3(:holidays="holidays", :titleInline="false")
            .caption.gray--text.mt-2 営業日時について
    v-col.py-0(v-if="isMobile", cols="12", style="position: relative")
      v-row.white(v-if="hasImages")
        v-col.py-0(cols="12", style="position: relative")
          v-carousel(v-model="slideCurrent", height="322", hide-delimiters)
            v-card(min-height="322", flat)
              v-carousel-item(
                v-for="(image, index) in office.top_images",
                :key="index",
                :src="image.image",
                :value="index",
                reserve-transition="fade-transition",
                transition="fade-transition"
              )
          .text-center.white--text.text-body-2.py-3.carousel-delimiters {{ slideCurrent + 1 }} / {{ office.top_images.length }}
        v-col.py-0(cols="12")
          .images__grid.pa-4
            v-card(
              v-for="(image, index) in office.top_images",
              :key="image.id",
              :class="{ active: index === slideCurrent }",
              dark,
              height="69",
              @click.stop="slideCurrent = index",
              tile
            )
              v-img(:src="image.image", width="100%")
      v-row.white(v-else)
        v-img(min-height="322", src="/images/no_image.png")
</template>

<script>
import Cookies from "js-cookie";
import CHoliday from "@/components/c-holiday";
import CComment from "@/components/c-comment";

export default {
  components: {
    CHoliday,
    CComment,
  },
  async asyncData(context) {
    const res = await context.$axios.$get(`/api/offices/${context.params.id}`);
    const holidays = res.regular_holidays.map((day) => day.holiday);
    const imageDetails = [
      {
        src: res.left_image.image || "/images/no_image.png",
        title: "画像の説明テキストが入ります画像の説明テキストが入ります",
      },
      {
        src: res.right_image.image || "/images/no_image.png",
        title: "画像の説明テキストが入ります画像の説明テキストが入ります",
      },
    ];
    return {
      office: res,
      staffs: res.staffs,
      holidays,
      imageDetails,
    };
  },
  data() {
    return {
      thanks: [],
      page: {
        currentPage: 1,
        totalPage: 1,
      },
      slideCurrent: 0,
      showStaff: false,
    };
  },

  computed: {
    hasImages() {
      return (
        this.office.top_images &&
        this.office.top_images[0] &&
        this.office.top_images[0].image
      );
    },
  },
  mounted() {
    this.$scrollToTop();
  },
  methods: {
    postThank() {
      if (!Cookies.get("access-token") || Cookies.get("staff")) {
        this.$router.push("/signin");
      } else {
        this.$store.dispatch("postThankStore", {
          officeName: this.office.name,
          staffs: this.staffs,
          officeId: this.$route.params.id,
        });
      }
    },
    postReserve() {
      if (!Cookies.get("access-token") || Cookies.get("staff")) {
        this.$router.push("/signin");
      } else {
        this.$store.dispatch("reserveStore", {
          reserveOfficeId: this.$route.params.id,
          reserveOfficeName: this.office.name,
        });
        Cookies.set("office_name", this.office.name);
        this.$router.push({ path: "/reserve" });
      }
    },
    toggleThanks(index, val) {
      this.$set(this.staffs[index], "show", val);
    },
    async toggleBookmark(id) {
      if (confirm("ブックマークに追加しますか？")) {
        await this.$axios.post("/api/v1/users/bookmarks", {
          office_id: id,
        });
      }
    },
  },
};
</script>
<style lang="scss" scoped>
.images_detail__grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-auto-rows: auto;
  column-gap: 8px;
  row-gap: 8px;
  width: 100%;
  .v-card {
    .v-image {
      position: absolute;
      height: 100%;
    }
  }
}
.images__grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  grid-auto-rows: auto;
  column-gap: 8px;
  row-gap: 8px;
  width: 100%;
  .v-card {
    overflow: hidden;
    &.active {
      border: 3px solid var(--v-primary-base);
    }
    .v-image {
      transition: all 0.2s;
      position: absolute;
      height: 100%;
      transform-origin: center;
    }
  }
}
.carousel-delimiters {
  position: absolute;
  bottom: 10px;
  width: 100%;
  text-shadow: 0 0 3px #000;
}
</style>
