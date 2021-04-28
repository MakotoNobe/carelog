<template lang="pug">
header
  v-app-bar(app)
    v-app-bar-nav-icon(@click="drawer = true")
    v-toolbar-title
      img.d-block(
        type="submit",
        src="@/static/logo/logo.svg",
        @click="$router.push({ name: 'index' })"
      )
    v-spacer
    v-slide-group(multiple)
      v-slide-item(v-for="(item, index) in items", :key="index")
        v-btn(
          v-if="item.logout === 'user'",
          depressed,
          @click="logout('user')"
        ) ログアウト
        v-btn(
          v-else-if="item.logout === 'staff'",
          depressed,
          @click="logout('staff')"
        ) ログアウト
        v-btn(v-else, depressed, @click="$router.push({ path: item.path })") {{ item.name }}
  v-navigation-drawer(v-model="drawer", fixed, temporary)
    v-list(nav, dense)
      v-list-item-group
        v-list-item(v-for="(item, index) in items", :key="index")
          v-list-item-title(
            v-if="item.logout === 'user'",
            @click="logout('user')"
          ) ログアウト
          v-list-item-title(
            v-else-if="item.logout === 'staff'",
            @click="logout('staff')"
          ) ログアウト
          v-list-item-title(v-else, @click="$router.push({ path: item.path })") {{ item.name }}
</template>
<script>
import Cookies from "js-cookie";
import initialMenu from "@/utils/headerMenu/initial.js";
import loggedInUserMenu from "@/utils/headerMenu/loggedInUser.js";
import loggedInStaffMenu from "@/utils/headerMenu/loggedInStaff.js";

export default {
  name: "Header",
  data() {
    return {
      headers: {
        uid: "",
        client: "",
        "access-token": "",
      },
      drawer: false,
      items: null,
    };
  },
  created() {
    this.headers.uid = Cookies.get("uid");
    this.headers.client = Cookies.get("client");
    this.headers["access-token"] = Cookies.get("access-token");
    if (Cookies.get("staff")) {
      this.items = loggedInStaffMenu.items;
    } else if (Cookies.get("access-token")) {
      this.items = loggedInUserMenu.items;
    } else {
      this.items = initialMenu.items;
    }
  },
  methods: {
    async logout(target) {
      if (target === "user") {
        const url = "/api/v1/signout";
        await this.$axios
          .delete(url, {
            headers: this.headers,
          })
          .then(() => {
            this.removeCookies();
            this.$router.push({ path: "/" });
            this.items = initialMenu.items;
            this.drawer = false;
          })
          .catch(() => {
            this.removeCookies();
            this.$router.push({ path: "/" });
            this.drawer = false;
          });
      }
      if (target === "staff") {
        this.removeCookies();
        Cookies.remove("staff", { path: "/" });
        this.$router.push({ path: "/" });
        this.items = initialMenu.items;
        this.drawer = false;
      }
    },
    removeCookies() {
      Cookies.remove("access-token", { path: "/" });
      Cookies.remove("client", { path: "/" });
      Cookies.remove("uid", { path: "/" });
      Cookies.remove("token-type", { path: "/" });
      Cookies.remove("user", { path: "/" });
      Cookies.remove("staff", { path: "/" });
    },
  },
};
</script>
