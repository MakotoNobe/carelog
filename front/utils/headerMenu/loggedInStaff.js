import Cookies from "js-cookie";

export default {
  items: [
    {
      name: "事業所情報編集",
      path: `/offices/edit/${Cookies.get("office-id")}`,
    },
    {
      name: "スタッフ情報",
      path: "/staffs",
    },
    {
      name: "お礼一覧",
      path: "/staffs/thanks",
    },
    {
      name: "予約状況確認",
      path: "/reserve/office",
    },
    {
      name: "利用者情報管理",
      path: "/patients",
    },
    {
      name: "ログアウト",
      logout: "staff",
    },
  ],
};
