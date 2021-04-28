<template lang="pug">
c-layout.pb-6(:container-class="{ 'px-0 pt-0': isMobile }")
  template(v-slot:header)
    v-container.pt-0(
      v-if="showStep1 || !isMobile",
      :class="{ 'pa-0': isMobile }"
    )
      v-card.px-4(
        dark,
        color="white",
        :height="isMobile ? 'auto' : 245",
        flat,
        tile
      )
        v-row.fill-height(align="center", justify="center")
          v-col.text-center(cols="12", :class="{ 'px-0': isMobile }")
            v-list-item.px-2(:class="{ 'text-left pt-2 px-3': isMobile }")
              v-list-item-content.pa-0
                v-list-item-title.font-weight-bold.gray--text.mb-2(
                  :class="{ 'text-h1': !isMobile, 'text-h4': isMobile }"
                ) 安心して介護をお願いしたいから。
                .gray--text(
                  :class="{ 'mb-7 text-body-2': !isMobile, 'mb-6': isMobile }",
                  :style="{ fontSize: isMobile ? '8.5px' : undefined }"
                ) ホームケアナビとは、ケアマネージャーの検索ができるサービスです。
              v-list-item-action.mt-n3.ml-0(v-if="isMobile")
                v-img(src="/images/heart_mobile.png", width="36")

            .pb-4.lightgray.mx-n3(v-if="isMobile")
            v-text-field.mx-auto(
              :class="{ 'pb-2 pt-5 px-3': isMobile }",
              placeholder="事業所名、市区町村など",
              outlined,
              rounded,
              v-model="inputKeyword",
              light,
              filled,
              hide-details,
              background-color="white",
              color="darkgray",
              append-icon="mdi-magnify",
              @keypress.enter="createSearchQueryByKeyword(inputKeyword)",
              @click:append="createSearchQueryByKeyword(inputKeyword)",
              style="max-width:720px"
            )
  div
    h2.mb-0.px-3.text-h4.font-weight-bold.darkgray--text(v-if="!isMobile") エリアから探す
    template(v-else)
      .mx-3(v-if="showStep2 || showStep3")
        h2.py-4.ma-0.text-h4.font-weight-bold.darkgray--text エリアから探す
        v-btn.justify-start(
          v-if="showStep2",
          x-small,
          color="bluegray",
          depressed,
          block,
          @click="step = 1"
        )
          v-icon(left, color="gray") mdi-chevron-left
          span.text-body-2 関東地方
        v-btn.justify-start(
          v-if="showStep3",
          x-small,
          color="bluegray",
          depressed,
          block,
          @click="step = 2"
        )
          v-icon(left, color="gray") mdi-chevron-left
          span.text-body-2 東京都
    v-row
      v-col.white.py-1(v-if="isMobile && showStep1", cols="12")
        .px-4
          v-divider
      v-col(
        v-if="showStep1 || !isMobile",
        cols="auto",
        :class="{ 'py-0': isMobile }"
      )
        c-card-arrow(
          :outlined="!isMobile",
          :width="isMobile ? '100%' : 392 - 16",
          :hideArrow="isMobile",
          :class="{ 'mr-4': !isMobile }"
        )
          v-btn(color="primary", large, outlined, block, depressed,@click="currentLocation()")
            font-awesome-icon.fas(icon="map-marker-alt")
            span.pl-3.subtitle-2.font-weight-bold 現在地から探す
          c-row.mt-2.mb-n2.overflow-hidden(xsmall)
            v-col(cols="4", v-for="area in areas", :key="area.id")
              v-btn(
                outlined,
                height="72",
                block,
                color="bluegray",
                @click="getPrefectureData(area)"
              )
                span.text-subtitle-2.font-weight-bold(
                  :class="currentArea.id === area.id ? 'darkgray--text font-weight-black' : 'gray--text'"
                ) {{ area.name }}
      v-col(v-if="showStep2 || !isMobile", :class="{ 'py-0': isMobile }")
        c-card-arrow(
          :height="isMobile ? 'auto' : undefined",
          :padding="isMobile ? 'pa-0' : 'pa-0'",
          :class="{ 'pa-6 pb-4 pr-0 mr-4': !isMobile, 'pl-3 py-0 mx-3': isMobile }",
          :hideArrow="isMobile",
          :outlined="!isMobile"
        )
          v-list.py-0(dense)
            template(v-if="isMobile")
              v-list-item.px-0
                v-list-item-content
                  v-list-item-title.text-h6.font-weight-regular.darkgray--text {{ currentArea.name }}
              v-divider.lightgray
            template(v-for="prefecture in prefectures")
              v-list-item.px-2(@click="getCityData(prefecture)")
                v-list-item-content
                  v-list-item-title.text-subtitle-2.darkgray--text(
                    :class="currentPrefecture.id === prefecture.id ? 'font-weight-bold' : 'font-weight-regular'"
                  ) {{ prefecture.name }}
                v-list-item-icon.mt-2.mb-0
                  v-icon(color="midgray") mdi-chevron-right
              v-divider.lightgray
      v-col(v-if="showStep3 || !isMobile", :class="{ 'py-0': isMobile }")
        c-card-arrow(
          hideArrow,
          :outlined="!isMobile",
          :padding="isMobile ? 'pa-0' : 'pa-6 pr-0 pb-0'",
          :class="{ 'pl-3 py-0 mx-3': isMobile }",
          overflow-hidden
        )
          v-card(v-if="step3Loading", :max-height="citiesScrollHeight")
            v-skeleton-loader(type="list-item@6")
          v-list.py-0(v-else, dense)
            template(v-if="isMobile")
              v-list-item.px-0
                v-list-item-content
                  v-list-item-title.text-h6.font-weight-regular.darkgray--text {{ currentPrefecture.name }}
              v-divider.lightgray
            v-virtual-scroll(
              :bench="3",
              :items="cities",
              :height="citiesScrollHeight",
              item-height="40"
            )
              template(v-slot:default="{ item }")
                v-list-item.px-2(:key="item.id")
                  v-list-item-content
                    v-list-item-title
                      v-checkbox.ma-0(
                        :value="item.id",
                        :ripple="false",
                        hide-details,
                        v-model="selectedCities"
                      )
                        template(v-slot:label)
                          span.text-subtitle-2.font-weight-regular.darkgray--text(
                            :class="selectedCities.includes(item.id) ? 'font-weight-bold' : 'font-weight-regular'"
                          ) {{ item.name }}
                  v-list-item-icon
                    v-icon(color="midgray") mdi-chevron-right
                v-divider.lightgray
          template(v-slot:actions, v-if="!isMobile")
            v-card.px-2(height="59", flat)
              v-row
                v-col.pr-1(cols="6")
                  v-btn(
                    color="bluegray",
                    outlined,
                    depressed,
                    block,
                    @click="selectedCities = []"
                  )
                    span.primary--text.subtitle-1.font-weight-bold クリア
                v-col.pl-1(cols="6")
                  v-btn(
                    color="primary",
                    depressed,
                    block,
                    @click="createSearchQueryByCity(selectedCities)",
                    :loading="filterLoading"
                  )
                    span.subtitle-1.font-weight-bold 検索する
        v-card.px-2(v-if="isMobile", height="59", flat)
          v-row
            v-col.pr-1(cols="6")
              v-btn(
                color="bluegray",
                outlined,
                depressed,
                block,
                @click="selectedCities = []"
              )
                span.primary--text.subtitle-1.font-weight-bold クリア
            v-col.pl-1(cols="6")
              v-btn(
                color="primary",
                depressed,
                block,
                @click="createSearchQueryByCity(selectedCities)",
                :loading="filterLoading"
              )
                span.subtitle-1.font-weight-bold 検索する
</template>

<script>
import CCardArrow from "~/components/c-card-arrow";

export default {
  name: "Home",
  components: {
    CCardArrow,
  },
  data() {
    return {
      areas: [],
      prefectures: [],
      cities: [],
      selectedCities: [],
      inputKeyword: "",
      step: 0,
      currentArea: {},
      currentPrefecture: {},
      step3Loading: false,
      filterLoading: false,
    };
  },
  computed: {
    showStep1() {
      return this.step === 1 && this.isMobile;
    },
    showStep2() {
      return this.step === 2 && this.isMobile;
    },
    showStep3() {
      return this.step === 3 && this.isMobile;
    },
    appHeight() {
      return this.$vuetify.breakpoint.height;
    },
    citiesScrollHeight() {
      return (this.isMobile ? this.appHeight - 185 : 326 - 24) - 56;
    },
  },
  created() {
    this.getFirstData();
  },
  mounted() {
    this.$scrollToTop();
  },
  methods: {
    // 初期読み込み時に東京の地区町村をデフォルトで表示させるメソッド
    async getFirstData() {
      this.filterLoading = false;
      this.selectedCities = [];
      const url = "/api/cities";
      const { areas, prefectures, cities } = await this.$axios.$get(url);
      this.areas = areas;
      this.prefectures = prefectures;
      this.cities = cities;
      //
      this.currentArea = areas.find(
        (item) => item.id === prefectures[0].area_id
      );
      this.currentPrefecture = prefectures.find(
        (item) => item.id === cities[0].prefecture_id
      );
      //
      //

      const areaCurrent = this.$route.query.area
        ? Number(this.$route.query.area)
        : null;
      const prefectureCurrent = this.$route.query.prefecture
        ? Number(this.$route.query.prefecture)
        : null;

      if (areaCurrent) {
        this.currentArea = this.areas.find((item) => item.id === areaCurrent);
        if (!prefectureCurrent) this.step = 2;
        await this.getPrefectureData(this.currentArea);
        //
        if (prefectureCurrent) {
          this.currentPrefecture = this.prefectures.find(
            (item) => item.id === prefectureCurrent
          );
          this.step = 3;
          await this.getCityData(this.currentPrefecture);

          //
          if (this.$route.query.cities) {
            if (Array.isArray(this.$route.query.cities)) {
              this.selectedCities = this.$route.query.cities;
            } else {
              this.selectedCities.push(this.$route.query.cities);
            }
          }
        }
      } else {
        this.step = 1;
      }
    },
    async getPrefectureData(item) {
      this.currentArea = item;
      this.step = 2;
      const url = `/api/cities?area_id=${item.id}`;
      this.prefectures = [];
      this.cities = [];
      await this.$axios.$get(url).then(({ prefectures }) => {
        this.prefectures = prefectures;
      });
    },
    async getCityData(item) {
      this.step3Loading = true;
      this.step = 3;
      this.currentPrefecture = item;
      const url = `/api/cities?prefecture_id=${item.id}`;
      this.cities = [];
      await this.$axios.$get(url).then(({ cities }) => {
        this.cities = cities;
      });
      this.step3Loading = false;
    },
    // キーワード検索時のクエリパラメータを生成するメソッド
    createSearchQueryByKeyword(keyword) {
      const keywordParams = `keyword=${keyword}`;
      this.getOfficesData(keywordParams, { keyword });
      this.inputKeyword = "";
    },
    // 地区町村を選択して検索をする時のクエリパラメータを生成するメソッド
    async createSearchQueryByCity(ids) {
      let cityParams = "";
      if (ids.length === 1) {
        cityParams = `city_number=${ids[0]}`;
      } else if (ids.length > 1) {
        ids.forEach((id) => {
          cityParams += `city_number[]=${id}&`;
        });
      } else {
        alert("市区町村を1つ以上選択してください。");
        return;
      }
      this.filterLoading = true;
      await this.getOfficesData(cityParams, {
        area: this.currentArea.id,
        prefecture: this.currentPrefecture.id,
        cities: ids,
      });
    },
    // 事業所を検索するAPIを叩いてレスポンスを返すメソッド
    async getOfficesData(queryParams, urlQuery) {
      this.$store.commit("setLoading", true);
      await this.$store.dispatch("searchOfficesData", {
        queryParams,
        urlQuery,
      });
      this.$store.commit("setLoading", false);
    },
    currentLocation() {
      const options = {
        enableHighAccuracy: true,
        maximumAge: 0,
      };
      const success = (pos) => {
        const crd = pos.coords;
        const latitude = crd.latitude;
        const longitude = crd.longitude;
        this.$store.dispatch("topLocationSearch", {
          latitude,
          longitude,
        });
      };
      const error = () => {
        alert(
          "通信エラーです。しばらくしてから再度クリックボタンを押してください"
        );
      };
      navigator.geolocation.getCurrentPosition(success, error, options);
    },
  },
};
</script>
<style lang="scss" scoped>
.area-search__grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: auto;
  column-gap: 8px;
  row-gap: 8px;
  width: 100%;
}
</style>
