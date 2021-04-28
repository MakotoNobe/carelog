<template lang="pug">
v-app
  c-appbar(
    :items="items",
    @onChangeDrawer="drawer = !drawer",
    @logout="logout",
    :isStaff="isStaffAuth"
  )
  v-main.lightgray
    c-main-scroll-viewer(:active="!isMobile")
      nuxt
      c-footer
  c-drawer(v-model="drawer", :items="items", @logout="logout")
</template>
<script>
import CAppbar from "@/components/c-appbar";
import CDrawer from "@/components/c-drawer";
import CFooter from "@/components/c-footer";
import CMainScrollViewer from "@/components/c-main-scroll-viewer.vue";

//
import Cookies from "js-cookie";
import initialMenu from "@/utils/headerMenu/initial.js";
import loggedInUserMenu from "@/utils/headerMenu/loggedInUser.js";
import loggedInStaffMenu from "@/utils/headerMenu/loggedInStaff.js";
import loggedInAdminMenu from "@/utils/headerMenu/loggedInAdmin.js";
export default {
  components: {
    CAppbar,
    CFooter,
    CDrawer,
    CMainScrollViewer,
  },
  data() {
    return {
      drawer: false,
      items: initialMenu.items,
      isStaffAuth: false,
    };
  },
  watch: {
    "$route.fullPath"() {
      this.loadMenu();
    },
  },
  created() {
    this.loadMenu();
    this.setLogout();
  },
  updated() {
    this.loadMenu();
  },
  methods: {
    loadMenu() {
      if (Cookies.get("access-token")) {
        if (Cookies.get("staff")) {
          this.items = loggedInStaffMenu.items;
          // こうしないと更新したcookies情報を取得したヘッダーにできない
          this.items[0].path = `/offices/edit/${Cookies.get("office-id")}`;
          // 配色やアイコンをスタッフ用に
          this.isStaffAuth = true;
        } else if (Cookies.get("admin")) {
          this.items = loggedInAdminMenu.items;
          // こうしないと更新したcookies情報を取得したヘッダーにできない
          this.items[0].path = `/admin/offices/edit/${Cookies.get(
            "office-id"
          )}`;
          // 配色やアイコンをスタッフ用に
          this.isStaffAuth = true;
        } else {
          this.items = loggedInUserMenu.items;
        }
      }
    },
    setLogout() {
      this.$nuxt.$on("logoutSet", this.logout);
    },
    async logout(target) {
      this.removeCookies();
      this.items = initialMenu.items;
      if (target === "user")
        try {
          await this.$axios.delete("/api/v1/signout");
        } catch (error) {}
      if (target === "admin")
        try {
          await this.$axios.delete("/api/v1/admin/signout");
        } catch (error) {}
      this.isStaffAuth = false;
      this.drawer = false;
      this.$router.push({ path: "/" });
    },
    removeCookies() {
      Cookies.remove("access-token", { path: "/" });
      Cookies.remove("client", { path: "/" });
      Cookies.remove("uid", { path: "/" });
      Cookies.remove("token-type", { path: "/" });
      Cookies.remove("user", { path: "/" });
      Cookies.remove("user-name", { path: "/" });
      Cookies.remove("login-status", { path: "/" });
      Cookies.remove("staff", { path: "/" });
      Cookies.remove("admin", { path: "/" });
      Cookies.remove("office-id", { path: "/" });
      Cookies.remove("office_id", { path: "/" });
      Cookies.remove("office_name", { path: "/" });
      Cookies.remove("office_email", { path: "/" });
    },
  },
};
</script>
<style></style>
