import Cookies from "js-cookie";

export default function ({ redirect }) {
  const cookiesId = Cookies.get("office-id");
  const url = location.pathname;
  const urlParams = url.match(/\d+/);
  if (cookiesId !== urlParams[0]) {
    return redirect("/");
  }
}
