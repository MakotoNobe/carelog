import Vue from "vue";

import CLayout from "@/components/c-layout.vue";
import CRow from "@/components/c-row.vue";

const components = { CLayout, CRow };

Object.entries(components).forEach(([name, component]) => {
  Vue.component(name, component);
});

/* eslint-disable */
export default ({}, inject) => {
  inject("scrollToTop", () => {
    document?.getElementById("scroller")?.scrollTo(0, 0);
  });
  Vue.mixin({
    computed: {
      isMobile() {
        return this.$vuetify.breakpoint.smAndDown;
      },
    },
  });
};
