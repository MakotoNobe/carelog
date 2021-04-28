<template lang="pug">
v-card.card-arrow(:outlined="outlined", flat, :width="width")
  v-card-text(:class="padding")
    div(
      :style="{ height: overflowHidden ? undefined : bodyHeight, overflowY: overflowHidden ? 'hidden' : 'auto', overflowX: 'hidden' }"
    )
      slot
  .arrow(v-if="!hideArrow")
    v-icon(size="62", color="bluegray") mdi-menu-right
    v-icon(size="60", color="white") mdi-menu-right
  slot(name="actions")
</template>

<script>
export default {
  props: {
    height: {
      type: [Number, String],
      required: false,
      default: 328,
    },
    width: {
      type: [Number, String],
      required: false,
      default: null,
    },
    hideArrow: {
      type: Boolean,
      required: false,
      default: false,
    },
    outlined: {
      type: Boolean,
      required: false,
      default: true,
    },
    padding: {
      type: String,
      required: false,
      default: "pa-4",
    },
    overflowHidden: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  computed: {
    hasActions() {
      return !!this.$slots.actions;
    },
    bodyHeight() {
      if (typeof this.height === "string") return this.height;
      const pa = (this.padding === "pa-4" ? 16 : 20) * 2;
      const h = this.height - pa;
      return (this.hasActions ? h - 32 : h) + "px";
    },
  },
};
</script>
<style lang="scss" scoped>
.card-arrow {
  .arrow {
    position: absolute;
    right: -35px;
    top: 50%;
    transform: translateY(-50%);
    width: 60px;
    height: 60px;
    i {
      position: absolute;
      left: 0;
      top: 50%;
      transform: translateY(-50%);
    }
  }
}
</style>
