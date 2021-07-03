<template>
  <div class=main style="color:red">
  <h2>メイン</h2>
  <ul v-for="(area,index) in areas " :key="`area-${index}`" >
      <li> 最初のliの中</li>
      <li @click="prechange(area.id)" > {{ area.name }}</li>
    </ul>
    <ul v-for="(prefecture,index) in prefectures " :key="`pre-${index}`" >
      <li> prefecturesの中</li>
      <li @click="citychange(prefecture.id)">{{ prefecture.name }}</li>
    </ul>
    <ul v-for="(city,index) in cities " :key="`city-${index}`" >
      <li> cityの中</li>
      <li> {{ city.name }}</li>
    </ul>
    <button><nuxt-link to="/offices" :cities="city" >検索</nuxt-link></button>
    <h1>  api  </h1>
  </div>
</template>
<script>
//
export default {
  data() {
    return {
      areas:[],
      prefectures:[],
      cities:[],
    }
  },
  created() {
    this.fristareacity();
    // ページが更新されたタイミングで関数を実行

  },
  methods: {    
      prechange(areid){
      const preapi = this.$axios.$get(`/api/v1/${areid}/3/cities`)
      console.log('preapiのコンソール'+preapi)
      preapi
      .then((res) => {
        console.log(res);
       return(
      this.areas = res.areas,
      this.prefectures = res.prefectures,
      this.cities = []
      ) 
      })
      .catch(() => {
          console.log('Do that');
      })      
      },
    citychange(preid){
      const citiesapi = this.$axios.$get(`/api/v1/${preid}/cities`)
      console.log('citiesapiのコンソール'+citiesapi)
      citiesapi
      .then((res) => {
        console.log(res);
       return(
      this.cities = res.cities
      ) 
      })
      .catch(() => {
          console.log('Do that');
      })      
      },
    async fristareacity(){
          const citiesapi = await this.$axios.$get('/api/v1/3/3/cities')
          // '/api/v1//3←市区町村が変わる/cities'
          this.areas = citiesapi.areas
          this.prefectures = citiesapi.prefectures
          this.cities = citiesapi.cities
        },
    }, 
    
    // loadMenu() {
    //   if (Cookies.get("access-token")) {
    //     if (Cookies.get("staff")) {
    //       this.items = loggedInStaffMenu.items;
    //       // こうしないと更新したcookies情報を取得したヘッダーにできない
    //       this.items[0].path = `/offices/edit/${Cookies.get("office-id")}`;
    //       // 配色やアイコンをスタッフ用に
    //       this.isStaffAuth = true;
    //     } else if (Cookies.get("admin")) {
    //       this.items = loggedInAdminMenu.items;
    //       // こうしないと更新したcookies情報を取得したヘッダーにできない
    //       this.items[0].path = `/admin/offices/edit/${Cookies.get(
    //         "office-id"
    //       )}`;
    //       // 配色やアイコンをスタッフ用に
    //       this.isStaffAuth = true;
    //     } else {
    //       this.items = loggedInUserMenu.items;
    //     }
    //   }
    // },
    // setLogout() {
    //   this.$nuxt.$on("logoutSet", this.logout);
    // },
    // async logout(target) {
    //   this.removeCookies();
    //   this.items = initialMenu.items;
    //   if (target === "user")
    //     try {
    //       await this.$axios.delete("/api/v1/signout");
    //     } catch (error) {}
    //   if (target === "admin")
    //     try {
    //       await this.$axios.delete("/api/v1/admin/signout");
    //     } catch (error) {}
    //   this.isStaffAuth = false;
    //   this.drawer = false;
    //   this.$router.push({ path: "/" });
    // },
    // removeCookies() {
    //   Cookies.remove("access-token", { path: "/" });
    //   Cookies.remove("client", { path: "/" });
    //   Cookies.remove("uid", { path: "/" });
    //   Cookies.remove("token-type", { path: "/" });
    //   Cookies.remove("user", { path: "/" });
    //   Cookies.remove("user-name", { path: "/" });
    //   Cookies.remove("login-status", { path: "/" });
    //   Cookies.remove("staff", { path: "/" });
    //   Cookies.remove("admin", { path: "/" });
    //   Cookies.remove("office-id", { path: "/" });
    //   Cookies.remove("office_id", { path: "/" });
    //   Cookies.remove("office_name", { path: "/" });
    //   Cookies.remove("office_email", { path: "/" });
    // },
    
   
};
</script>
<style>
.header{
  background:white;
  padding:1em 1em;
}
.header nav{
  display: flex;
  padding:0 145px ;
  justify-content: space-between;
}
.header ul{
list-style: none;
display: flex;
}
.header ul li{
  padding-top: 10px;
  padding-left: 20px;
  font-size:13px;
  color:grey;
}
.header ul button{
  border: 1px solid black;
  margin-left:20px;
  padding: 4px 40px;
  text-align: center;
  border-radius: 2px;
}
.header ul button:nth-last-child(1){
  background:#FF9966;
}
.header ul button:nth-last-child(1) a{
color:white;
}

.header ul button a{
text-decoration: none;
}

.footer {
  bottom: 0;
  width: 100%;
  position: absolute;/* ←絶対位置 */
  margin-bottom: auto;
  background-color:#fff;
}

.logo{
  display: inline-block;
  margin-left: auto;
}

.logo a {
  text-decoration: none;
  padding-left: 200px ;
  display: inline-block;
  margin-bottom: 10px;
  color:black;
  cursor:pointer;
}

#copy{
  font-size:10px;
  padding-left:20px;
  color:gray;
  padding-top: 4px
}

.nav li a {
  color:red;
  text-decoration: none;
}

.nav li {
    display: inline-block;
    font-size:12px;
    margin-left:10px;
    padding-right: 15px;
    justify-content: space-between;
    cursor:pointer;
  }


.nav {
  text-align: right;
  padding-right: 145px;
  margin-bottom: 10px;
}
</style>

