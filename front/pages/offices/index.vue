<template lang="pug">
c-layout
  v-row.text-h5
    v-col(:cols="isMobile ? 12 : 3")
      v-card.pa-3(:width="isMobile ? 'auto' : 245")
        h3.text-h5.font-weight-bold.darkgray--text.mb-4 検索条件
        .wrap-full
          v-text-field.mx-auto.font-weight-normal.search_form(
            outlined,
            rounded,
            light,
            filled,
            hide-details,
            background-color="white",
            append-icon="mdi-magnify",
            color="darkgray",
            v-model="inputKeyword",
            @keypress.enter="searchByKeyword(inputKeyword)",
            @click:append="searchByKeyword(inputKeyword)"
          )
        .wrap-full
          .geocode
            v-divider.mt-4.mb-1.bluegray
            .mb-1.curent_location.darkgray--text
              v-btn.darkgray--text.justify-space-between.px-2(
                block,
                text,
                color="drakgray",
                @click.stop="isMobile ? mobileBackToFilter() : undefined",
                :ripple="isMobile"
              )
                div
                  span.pr-2 エリア
                  span.text-subtitle-2.font-weight-regular 現在地周辺（7km）
                v-icon(v-if="isMobile", color="midgray", small) mdi-chevron-right
            .geocode__btn
              v-btn(
                color="bluegray",
                outlined,
                depressed,
                block,
                @click="currentLocation()"
              )
                span.primary--text 現在地から探す
        template(v-if="!isMobile")
          .wrap-full.mt-7.pl-3
            v-breadcrumbs.pa-0(:items="breadcrumbs", divider=">")
              template(v-slot:item="{ item }")
                v-breadcrumbs-item
                  a.darkgray--text(@click="switchSidebar(item.place)") {{ item.link }}
          .wrap-full
            .areas
              v-list.select-area(flat, v-if="sidebar.area")
                v-list-item-group(v-for="(area, index) in areas", :key="index")
                  v-list-item.px-2.subtitle-2.mh-10(
                    @click="nextShow('area', 'prefecture', area.name); getPrefectureData(area.id)",
                    :class="currentArea.id === area.id ? 'font-weight-bold' : 'font-weight-regular'"
                  )
                    | {{ area.name }}
                    v-spacer
                    v-list-item-icon.my-2
                      v-icon(v-text="'mdi-chevron-right'")
              v-list.select-prefecture(flat, v-if="sidebar.prefecture")
                v-list-item-group(
                  v-for="(prefecture, index) in prefectures",
                  :key="index"
                )
                  v-list-item.px-2.subtitle-2.mh-10(
                    @click="nextShow('prefecture', 'city', prefecture.name); getCityData(prefecture.id)",
                    :class="currentPrefecture.id === prefecture.id ? 'font-weight-bold' : 'font-weight-regular'"
                  )
                    | {{ prefecture.name }}
                    v-spacer
                    v-list-item-icon.my-2
                      v-icon(v-text="'mdi-chevron-right'")
              v-list(dense, v-if="sidebar.city")
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
              v-btn(
                block,
                depressed,
                color="primary",
                :loading="filterLoading",
                @click="searchByCity(selectedCities)"
              ) 検索する
    v-col(:class="{ 'px-6': isMobile }", :cols="isMobile ? 12 : 9")
      h3.title.font-weight-bold 検索結果
      h6.body-1.font-weight-bold.gray--text {{ page.totalCount }}件
      c-row.mt-1(small)
        v-col(
          v-for="(office, index) in offices",
          :key="index",
          cols="12",
          md="6"
        )
          c-card.mb-3(
            :key="index",
            :office="office",
            :toggleBookmark="addBookmark"
          )
      v-col.fixed-bottom(cols="12")
        v-pagination(
          v-model="page.currentPage",
          :length="page.totalPage",
          @input="changePage",
          color="bluegray"
        )
</template>

<script>
import CCard from "@/components/c-card";

export default {
  components: {
    CCard,
  },
  data() {
    return {
      offices: [],
      page: {
        currentPage: 1,
        totalPage: 1,
        totalCount: 0,
      },
      areas: [],
      prefectures: [],
      cities: [],
      selectedCities: [],
      sidebar: {
        area: true,
        prefecture: false,
        city: false,
      },
      breadcrumbs: [],
      latitude: "",
      longitude: "",
      inputKeyword: "",
      currentArea: {},
      currentPrefecture: {},
      filterLoading: false,
    };
  },
  computed: {
    citiesScrollHeight() {
      return this.$vuetify.breakpoint.height - 430;
    },
  },
  created() {
    // sidebarの初期データの呼び出し
    this.getFirstData();
    // mainページのデータの描画
    this.mountOffices();
  },
  mounted() {
    this.$scrollToTop();
  },
  methods: {
    // 初期表示用のデータを入れるためのメソッド
    async getFirstData() {
      this.inputKeyword = this.$route.query.keyword;
      const url = "/api/cities";
      const { areas } = await this.$axios.$get(url);
      this.areas = areas;
      //
      const areaCurrent = this.$route.query.area
        ? Number(this.$route.query.area)
        : null;
      if (areaCurrent) {
        this.currentArea = this.areas.find((item) => item.id === areaCurrent);
        this.nextShow("area", "prefecture", this.currentArea.name);
        await this.getPrefectureData(areaCurrent);
        //
        const prefectureCurrent = this.$route.query.prefecture
          ? Number(this.$route.query.prefecture)
          : null;
        if (prefectureCurrent) {
          this.currentPrefecture = this.prefectures.find(
            (item) => item.id === prefectureCurrent
          );
          this.nextShow("prefecture", "city", this.currentPrefecture.name);
          await this.getCityData(prefectureCurrent);

          //
          if (this.$route.query.cities) {
            if (Array.isArray(this.$route.query.cities)) {
              this.selectedCities = this.$route.query.cities;
            } else {
              this.selectedCities.push(this.$route.query.cities);
            }
          }
        }
      }
    },
    // store内に管理しているstateの情報を取得しページに描画するメソッド
    mountOffices() {
      this.page.totalPage = Number(this.$store.getters.getTotalPage);
      this.page.currentPage = this.$store.getters.getCurrentPage;
      this.page.totalCount = Number(this.$store.getters.getTotalCount);
      this.offices = this.$store.getters.getOfficesData;
    },
    async changePage(val) {
      await this.$store.dispatch("searchOfficesData", {
        queryParams: this.$store.getters.getCurrentParams,
        val,
      });
      this.offices = this.$store.getters.getOfficesData;
      this.$vuetify.goTo(0);
    },
    // sidebarでエリア・都道府県を選択したら表示・非表示を切り替えて、パンくずリストのリンク先のエリア名を生成するメソッド
    nextShow(current, next, breadcrumbs) {
      setTimeout(() => {
        this.sidebar[current] = false;
        this.sidebar[next] = true;
        this.breadcrumbs.push({
          link: breadcrumbs,
          place: current,
        });
      }, 500);
    },
    // パンくずリストをクリックしたら時にサイドバーを切り替えるメソッド
    switchSidebar(place) {
      this.sidebar.area = false;
      this.sidebar.prefecture = false;
      this.sidebar.city = false;
      this.sidebar[place] = !this.sidebar[place];
      if (place === "prefecture") {
        this.breadcrumbs.pop();
      }
      if (place === "area") {
        this.breadcrumbs = [];
      }
    },
    // inputで入力されたキーワードを検索にかけてmountするメソッド
    async searchByKeyword(keyword) {
      const queryParams = keyword ? `keyword=${keyword}` : ``;
      await this.$store.dispatch("searchOfficesData", {
        queryParams,
        noPush: true,
      });
      this.mountOffices();
    },
    // 市区町村で検索したときに検索結果をmountするメソッド
    async searchByCity(ids) {
      let queryParams = "";
      if (ids.length === 1) {
        queryParams = `city_number=${ids[0]}`;
      } else if (ids.length > 1) {
        ids.forEach((id) => {
          queryParams += `city_number[]=${id}&`;
        });
      } else {
        alert("市区町村を1つ以上選択してください。");
        return false;
      }
      this.filterLoading = true;
      await this.$store.dispatch("searchOfficesData", {
        queryParams,
        urlQuery: {
          area: this.currentArea.id,
          prefecture: this.currentPrefecture.id,
          cities: this.selectedCities,
        },
        noPush: true,
      });
      // this.selectedCities = [];
      this.mountOffices();
      this.filterLoading = false;
    },
    // sidebarでエリアを検索した時に表示が切り替わる
    async getPrefectureData(id) {
      this.currentArea = this.areas.find((item) => item.id === id);
      const url = `/api/cities?area_id=${id}`;
      this.prefectures = [];
      this.cities = [];
      await this.$axios.$get(url).then(({ prefectures }) => {
        this.prefectures = prefectures;
      });
    },
    // sidebarで都道府県を検索した時に表示が切り替わる
    async getCityData(id) {
      this.currentPrefecture = this.prefectures.find((item) => item.id === id);
      const url = `/api/cities?prefecture_id=${id}`;
      this.cities = [];
      await this.$axios.$get(url).then(({ cities }) => {
        this.cities = cities;
      });
    },
    // 現在地を取得するメソッド
    currentLocation() {
      const options = {
        enableHighAccuracy: true,
        maximumAge: 0,
      };
      const success = async (pos) => {
        const crd = pos.coords;
        this.latitude = crd.latitude;
        this.longitude = crd.longitude;
        console.log(this.latitude);
        console.log(this.longitude);
        const url = `api/getoffice?latitude=${this.latitude}&longitude=${this.longitude}`;
        await this.$axios.get(url).then((res) => {
          this.offices = res.data;
          this.page.totalPage = Number(res.headers["total-pages"]);
        });
      };
      const error = () => {
        alert(
          "通信エラーです。しばらくしてから再度クリックボタンを押してください"
        );
      };
      navigator.geolocation.getCurrentPosition(success, error, options);
    },
    mobileBackToFilter() {
      this.$router.push({
        path: "/",
        query: {
          area: this.currentArea.id,
          prefecture: this.currentPrefecture.id,
          cities: this.selectedCities,
        },
      });
    },
    // ブックマーク
    async addBookmark(id) {
      if (confirm("ブックマークに追加しますか？")) {
        await this.$axios.post("/api/users/bookmarks", {
          office_id: id,
        });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.sidebar {
  background: white;
  height: fit-content;
}
.geocode,
.areas,
.search-box {
  width: 100%;
}

.v-input__append-inner {
  margin-top: 0 !important;
}

.far {
  display: flex;
}
.curent_location {
  span {
    font-size: 11px;
    font-weight: bold;
  }
  button {
    font-size: 14px;
    font-weight: normal;
  }
}
.mh-10 {
  min-height: 40px;
}
</style>
