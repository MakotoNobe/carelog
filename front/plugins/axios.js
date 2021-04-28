import Cookies from "js-cookie";

export default function ({ $axios }) {
  $axios.setToken("access_token");

  $axios.onResponse(() => {
    $axios.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
  });

  $axios.onRequest((config) => {
    config.headers.client = Cookies.get("client");
    config.headers["access-token"] = Cookies.get("access-token");
    config.headers.uid = Cookies.get("uid");
    config.headers["token-type"] = Cookies.get("token-type");
  });

  //   $axios.onResponse((response) => {
  //     if (response.headers.client) {
  //       Cookies.set("access-token", response.headers["access-token"]);
  //       Cookies.set("client", response.headers.client);
  //       Cookies.set("uid", response.headers.uid);
  //       Cookies.set("token-type", response.headers["token-type"]);
  //     }
  //   });
}
