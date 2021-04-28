import Vue from "vue";
import {
  ValidationProvider,
  ValidationObserver,
  extend,
  localize,
  configure,
} from "vee-validate";
import { required, email, min, confirmed } from "vee-validate/dist/rules";
import ja from "vee-validate/dist/locale/ja.json";

extend("required", required);
extend("min", min);
extend("confirmed", confirmed);
extend("email", {
  ...email,
  message: "有効なメールアドレスではありません",
});
extend("tel", (value) => {
  const telRegExp = /^0\d{1,4}-\d{1,4}-\d{3,4}$/;
  if (telRegExp.exec(value)) return true;
  return "有効な電話番号ではありません";
});

extend("postalCode", (value) => {
  const telRegExp = /^[0-9]{3}[0-9]{4}$/;
  if (telRegExp.exec(value)) return true;
  return "有効な郵便番号ではありません";
});

configure({
  classes: {
    valid: "is-valid",
    invalid: "is-invalid",
  },
});

localize("ja", ja);

Vue.component("ValidationProvider", ValidationProvider);
Vue.component("ValidationObserver", ValidationObserver);
