<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="3" outlined >
        <v-sheet
        color="success"
        width="250"
        outlined
        tile
        class="pa-2"
        >
        <h3 class="pt-2">検索条件</h3>
        <v-text-field  outlined placeholder="検索窓" class="pr-2 pt-2" rounded append-icon="mdi-magnify"></v-text-field>
        <!-- <v-text-field  outlined placeholder="検索窓" class="pr-2 pt-2" rounded append-icon="mdi-magnify" @click:append="getquery"></v-text-field> -->
        <hr width=220 size=3>
        <h4 class="pt-2"> エリア 現在地周辺（）</h4>
        <v-btn  shaped class="btnsize location"><h3> 現在地から探す</h3></v-btn>
        <p>{{seleArea.name}} > {{selePre.name}}</p>
        <v-virtual-scroll
        :bench="benched"
        :items="cities"
        height="300"
        item-height="64"
      >
        <template v-slot:default="{ item }">
          <v-list-item :key="item.id">
            <v-list-item-action>
             <!-- <v-checkbox
              v-model="checkbox"
              :label="`Checkbox 1: ${checkbox.toString()}`"
            ></v-checkbox> -->
            <v-checkbox></v-checkbox>
            </v-list-item-action>
            <v-list-item-content>{{ item.name }}</v-list-item-content>
            </v-list-item>
            <v-divider></v-divider>
            </template>
         </v-virtual-scroll>
         <v-btn class="btnsize btn">検索</v-btn>
        </v-sheet>
      </v-col>
      <v-col cols="9" outlined>
        <v-row>
              <v-col cols="12" outlined>
              <h1>検索結果</h1>
              <span>{{officeindex}}件</span>
              </v-col>
        </v-row>
        <v-row>
          <v-col cols="6" v-for="officedata in officedatas " :key="officedata.id" outlined>
             <v-col>
              <span>web予約可</span>
              <h2>事業所名: {{officedata.name}} <v-icon>mdi-heart-outline</v-icon></h2>
             </v-col>
              <br>
              <v-row>
                <v-col>
                <v-img src="https://placehold.jp/120x120.png" height="150" width="200"></v-img>
                </v-col>
                <v-col>
                <span><v-icon>mdi-account</v-icon>{{ officedata.staff_number }}</span>
                <br>
                <span><v-icon>mdi-map-marker-radius-outline</v-icon>{{ officedata.address }}</span>
                <br>
                <span><v-icon>mdi-phone</v-icon>{{ officedata.tel }}</span>
                <br>
                <span><v-icon>mdi-fax</v-icon>{{ officedata.fax }}</span>
                </v-col>
              </v-row>
              <br>
            <span><v-icon>mdi-account</v-icon>ユーザーからのお礼コメントまだ口コミはありません。</span>
            <br>
            <v-row>
                <v-col cols="2">
                <span>営業日</span>
                </v-col>
                <v-col cols="10">
                <v-simple-table>
                  <template outlined>
                    <thead>
                      <tr >
                        <th class="opendays">日</th>
                        <th class="opendays">月</th>
                        <th class="opendays">火</th>
                        <th class="opendays">水</th>
                        <th class="opendays">木</th>
                        <th class="opendays">金</th>
                        <th class="opendays">土</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                        <td  class="opendays">◯</td>
                      </tr>
                    </tbody>
                  </template>
                </v-simple-table>
                </v-col>
            </v-row>
            </v-col>
        </v-row>
      </v-col>
    </v-row>
  </v-container>

</template>

<script>
  export default {
    data() {
      return {
        benched: 0,
        areas:[],
        prefectures:[],
        cities:[],
        preid:[],
        seleArea:[],
        selePre:[],
        officeindex:[],
        officedatas:[],
      }
    },
    created() {
       this.gt();
    // ページが更新されたタイミングで関数を実行
     },
    methods: {
      async gt(){
        const cityquery = this.$route.query.city
        const prefecturequery =  this.$route.query.prefecture
        const areaquery = this.$route.query.area
        const officeAPI = await this.$axios.$get(`/api/v1/offices?area=${areaquery}&prefecture=${prefecturequery}&cities[]=${cityquery}`)
        this.officedatas = officeAPI.offices
        this.officeindex = officeAPI.offices.length
        // クエリから検索する市区町村を表示する
        const citiesshow = await this.$axios.$get(`/api/v1/${areaquery}/${prefecturequery}/cities`)
        const preshow = await this.$axios.$get(`/api/v1/${prefecturequery}/cities`)
        this.areas = citiesshow.areas
        this.prefectures = citiesshow.prefectures
        this.cities = preshow.cities
        this.seleArea = this.areas.find((v) => v.id === this.prefectures[0].area_id);
        this.selePre = this.prefectures.find((v) => v.id === this.cities[0].prefecture_id);
      },
    },
  }

</script>

<style scoped>
.pa-2{
  padding-left:8px;
}
.pt-2{
  padding-top:8px;
}
.pr-2{
  padding-right:8px;
}
.radius{
  border-radius:30px;
}
.btnsize{
  height: 100px;
  width: 200px;
  margin: 8% !important;
  padding: 20px !important;
}
.location{
 color:rgb(0, 80, 152) !important;;
}
.btn{
color:#FFF !important;;
background-color: rgb(0, 80, 152) !important;
}
.opendays{
  color:black;
  border:solid 0.2px black;
}
</style>
