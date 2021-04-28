<template lang="pug">
v-navigation-drawer(
  :value="value",
  @input="$emit('input', $event)",
  fixed,
  app,
  right,
  :mobile-breakpoint="mobileBreakpoint",
  disable-resize-watcher,
  width="296"
)
  v-card.py-3(color="lightgray", height="198", flat)
    v-card-text.pb-4
      v-list-item
        v-list-item-content.text-center
          nuxt-link.text-decoration-none.fill-height(to="/")
            v-img.mx-auto(
              src="/logo/logo.svg",
              contain,
              height="100%",
              width="150",
              alt="Logo"
            )
      .text-center.text-body-2.font-weight-medium.gray--text {{ userName }}
    v-card-actions.px-6
      v-row.no-gutters
        v-col(
          v-for="(item, i) in items.filter((it) => it.authButton)",
          :key="i"
        )
          v-btn(
            v-if="item.signin",
            color="bluegray",
            small,
            outlined,
            depressed,
            :to="item.path",
            width="120"
          )
            span.gray--text {{ item.name }}
          v-btn.ml-1(
            v-else,
            color="primary",
            small,
            depressed,
            width="120",
            :to="item.path"
          )
            span {{ item.name }}
    .pt-1.text-center.text-body-2.font-weight-medium.primary--text ケアマネージャーの方はこちら
  v-list.pa-0(dense)
    template(v-for="(item, i) in items")
      v-list-item.pl-6.py-1(
        :to="item.path",
        router,
        exact,
        v-if="!item.authButton",
        @click="item.logout ? logout(item.logout) : null"
      )
        v-list-item-content.py-1 {{ item.name }}
        v-list-item-icon
          v-icon(color="midgray") mdi-chevron-right
      v-divider(v-if="!item.authButton")
</template>

<script>
import Cookies from "js-cookie";

export default {
  props: {
    value: {
      type: Boolean,
      default: false,
    },
    items: {
      type: Array,
      required: false,
      default: () => [],
    },
  },
  data() {
    return {
      userName: "ゲストさん",
    };
  },
  computed: {
    mobileBreakpoint() {
      return 959;
    },
  },
  updated() {
    if (Cookies.get("login-status")) {
      this.userName = `${decodeURIComponent(Cookies.get("user-name"))}さん`;
    }
  },
  methods: {
    logout(taget) {
      this.$emit("logout", taget);
    },
  },
};
</script>

<style></style>
