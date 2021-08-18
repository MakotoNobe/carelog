<template>
  <v-main>
    <v-container class="pt-0 pb-4">
      <v-sheet color="white" elevation="1" height="245">
          <div class="title-text">
          <div class="main-text">安心して介護をお願いしたいから。</div>
          <div class="sub-text">
            ホームケアナビは、ケアマネージャーの検索ができるサービスです。
          </div>
        </div>
        <div class="keywords">
          <input
            type="“text”"
            name="“search”"
            class="“searchkeywords”"
            placeholder="“事業所名、市区町村など“"
          />
          <button>
            <img
              src="../static/images/search.png"
              width="“20px”"
              height="“20px”"
            />
          </button>
        </div>
    </v-sheet>
        <h2 class="area-text">エリアから探す</h2>
        <v-row>
          <v-col cols="5" class="areacolfirst">
             <v-row>
                <v-col cols="12">
                      <button
                        type="button"
                        class="v-btn v-btn--block v-btn--depressed  v-btn--outlined theme--light v-size--large primary--text"
                      >
                        <span class="v-btn__content">
                          <img
                            src="../static/images/current_location.png"
                            alt="現在地探す"
                          />
                          <div class="current-content">
                            現在地から探す
                          </div>
                        </span>
                      </button>
                </v-col>
                <v-col cols="12" class="areacolsecond">
                  <v-row class="arearow">
                    <v-col cols="3" v-for="(area,index) in areas " :key="`area-${index}`" @click="prechange(area.id)">
                        {{ area.name }}
                    </v-col>
                  </v-row>
                </v-col>
              </v-row>
          </v-col>
          <v-spacer></v-spacer>
          <v-col cols="3">
            <v-row class="arearow prefecturecity">
                  <v-virtual-scroll
                    :bench="benched"
                    :items="prefectures"
                    height="380"
                    item-height="55"
                  >
                  <template v-slot:default="{ item }">
                      <v-list-item :key="item.length">
                        <v-list-item-content @click="citychange(item.id)">{{ item.name }}</v-list-item-content>
                    </v-list-item>
                    <v-divider></v-divider>
                  </template>
                  </v-virtual-scroll>
            </v-row>
          </v-col>
          <v-spacer></v-spacer>
          <v-col cols="3">
              <v-row class="arearow prefecturecity">
                  <v-col cols="12">
                  <v-virtual-scroll
                    :bench="benched"
                    :items="cities"
                    height="300"
                    item-height="50"
                  >
                    <template v-slot:default="{ item }">
                      <v-list-item :key="item.length">
                        <v-list-item-action>
                        <v-checkbox :id="item.city_number" :value="item.city_number" v-model="checkedcity"></v-checkbox>
                        </v-list-item-action>
                        <v-list-item-content>{{ item.name }}</v-list-item-content>
                        </v-list-item>
                        <v-divider></v-divider>
                        </template>
                    </v-virtual-scroll>
              </v-col>
              <v-col>
               <v-btn>
                      クリア
                    </v-btn>
                    <v-btn @click="selectedcity">
                      検索する
                    </v-btn>
              </v-col>
              </v-row>
          </v-col>
        </v-row>
    </v-container>
  </v-main>
</template>

<script>
export default {
  name: "Home",
  data() {
    return {
      benched: 0,
      areas: [],
      prefectures: [],
      cities: [],
      querycity: [],
      checkedcity: [],
      areanumber: [],
      prefecturenum: [],
    };
  },
  created() {
    this.fristareacity();
    // ページが更新されたタイミングで関数を実行
  },
  methods: {
    prechange(areid) {
      const preapi = this.$axios.$get(`/api/v1/${areid}/3/cities`);
      console.log("preapiのコンソール" + preapi);
      const areanumber = areid;
      preapi
        .then((res) => {
          console.log(res);
          return (
            (this.areas = res.areas),
            (this.prefectures = res.prefectures),
            (this.cities = []),
            (this.areanumber = areanumber)
          );
        })
        .catch(() => {
          console.log("Do that");
        });
    },
    citychange(preid){
      const citiesapi = this.$axios.$get(`/api/v1/${preid}/cities`)
      console.log('citiesapiのコンソール'+citiesapi)
      const prefecturnum = preid
      citiesapi
      .then((res) => {
        console.log(res);
       return(
      this.cities = res.cities,
      this.prefecturenum = prefecturenum
      )
      })
      .catch(() => {
          console.log('Do that');
      })
      },
    selectedcity(checkedcity) {
      const selected = this.checkedcity;
      const areanumber = this.areanumber;
      const prefecturenum = this.prefecturenum;
      this.$router.push({
        name: "offices",
        path: "/offices/:area/:prefecture/:city",
        query: {
          area: `${areanumber}`,
          prefecture: `${prefecturenum}`,
          city: `${selected}`,
        },
      });
    },
    async fristareacity() {
      const citiesapi = await this.$axios.$get("/api/v1/3/3/cities");
      // '/api/v1//3←市区町村が変わる/cities'
      this.areas = citiesapi.areas;
      this.prefectures = citiesapi.prefectures;
      this.cities = citiesapi.cities;
      this.areanumber = 3;
      this.prefecturenum = 3;
    },
  },
};
</script>
<style lang="scss" scoped>

.v-main{
  background-color:#f5f7f7;
  .container{
    padding-top: 0;
    padding-bottom: 2em;
  }
}
.areacolfirst{
  background-color:white;
  .arearow{
    .col{
      margin:10px 20px;
      padding:25px 15px;
      border: black 1px solid;
      text-align: center;
    }
  }
}
.current-content {
  color: #f06364;
}

.v-sheet {
  margin-right: auto;
  margin-left: auto;
}


.row {
  padding-top: 12px;
}

.prefecturecity{
  background-color: #FFF;
  button:nth-last-child(1) a {
    color: white;
  }
  button:nth-last-child(1) {
    background: #ff9966;
}
.col {
  display: flex;
  margin:0 auto;
}
}
.area-text {
  padding-top: 16px;
}

.card {
  background-color: #fff;
  padding-left: 6px;
  padding-right: 6px;
  padding-top: 6px;
    .arearow{
    .col{
      margin: 3px;
      border: black 1px solid;
      align-items: center;
      justify-content: center;
    }
  }
}

img {
  width: 16px;
  height: 18px;
}

.v-btn {
  height: 44px;
  padding: 0;
  margin: auto;
}

.title-text {
  text-align: center;
  padding-top: 48px;
  padding-bottom: 28px;
}

.main-text {
  font-size: 28px;
}

.sub-text {
  font-size: 12px;
}
.keywords {
  border: 1px solid lightgrey;
  border-radius: 30px;
  width: 480px;
  height: 2em;
  margin-left: auto;
  margin-right: auto;
}
input {
  width: 90%;
}
.searchkeywords::placeholder {
  text-align: left;
}
.keywords button {
  line-height: 2em;
}
</style>
