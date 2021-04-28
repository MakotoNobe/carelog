<template lang="pug">
v-app-bar.c-app-bar(
  fixed,
  app,
  clipped-right,
  color="white",
  :height="isMobile ? 52 : 60"
)
  v-container.py-0(:class="{ 'px-0': isMobile }")
    v-row
      v-col.d-flex(cols="12")
        nuxt-link.text-decoration-none.fill-height.d-flex.align-center(to="/")
          v-img(
            src="/logo/logo.svg",
            contain,
            height="100%",
            width="150",
            alt="Logo"
          )
          v-chip.ml-2.px-2(
            v-if="isStaff",
            x-small,
            label,
            color="staffcolor",
            chip,
            dark
          ) Staff
        v-spacer
        v-toolbar-items.hidden-sm-and-down
          template(v-for="(item, i) in items")
            v-btn(
              v-if="!item.authButton",
              text,
              :key="i",
              :to="item.path",
              router,
              exact,
              @click="item.logout ? logout(item.logout) : null"
            )
              span.text-body-1.font-weight-medium.gray--text {{ item.name }}
        template(v-for="(item, i) in items")
          .hidden-md-and-down(v-if="item.authButton")
            v-btn(
              v-if="item.signin",
              color="bluegray",
              small,
              outlined,
              depressed,
              :to="item.path"
            )
              span.gray--text {{ item.name }}
            v-btn.ml-3(
              v-else,
              color="primary",
              small,
              depressed,
              :to="item.path"
            )
              span {{ item.name }}
  v-btn(v-if="isMobile", icon, @click.stop="onChangeDrawer")
    v-icon mdi-menu
</template>

<script>
export default {
  props: {
    items: {
      type: Array,
      required: false,
      default: () => [],
    },
    isStaff: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  watch: {
    // Close Drawer when resize screen from mobile to desktop
    isMobile(val) {
      if (this.drawer && !val) {
        this.drawer = false;
      }
    },
  },
  methods: {
    onChangeDrawer() {
      this.$emit("onChangeDrawer");
    },
    logout(taget) {
      this.$emit("logout", taget);
    },
  },
};
</script>
