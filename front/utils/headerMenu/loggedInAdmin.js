import Cookies from "js-cookie";

export default {
  items: [
    {
      name: "事業所情報編集",
      path: `/admin/offices/${Cookies.get("office-id")}`,
    },
    {
      name: "ログアウト",
      logout: "admin",
    },
  ],
};
