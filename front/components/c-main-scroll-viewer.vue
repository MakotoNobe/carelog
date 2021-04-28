<template>
  <div
    id="scroller"
    class="overflow-x-hidden"
    :class="{
      'overflow-y-auto': active,
    }"
    :style="active && appBarHeight > 0 ? mainStyle : null"
  >
    <div :style="active && appBarHeight > 0 ? mainContentStyle : null">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    active: {
      type: Boolean,
      default: true,
    },
  },
  computed: {
    appBarHeight() {
      return this.$vuetify.application.top;
    },
    mainStyle() {
      return {
        height: `calc(100vh - ${this.appBarHeight}px)`,
      };
    },
    mainContentStyle() {
      return {
        minHeight: `calc(100vh - ${this.appBarHeight}px)`,
      };
    },
  },
};
</script>

<style></style>
