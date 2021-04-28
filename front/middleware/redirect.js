import Cookies from "js-cookie";

export default function ({ redirect }) {
  const token = Cookies.get("access-token");
  if (!token) {
    return redirect("/signin");
  }
}
