<template lang="pug">
.c-layout(:style="{ minHeight: `${minHeight}px` }", v-resize="onResize")
  v-container.pa-0(:style="containerFit")
    slot(name="header")
    v-row(v-if="center && !isMobile", align="center", justify="center")
      v-col(cols="auto")
        v-card.mx-auto.mt-7(
          width="750",
          flat,
          color="transparent",
        )
          slot 
    template(v-else)
      v-container(
        :class="{ 'pa-0 mt-n1': isMobile, 'pt-7': !isMobile && !hasHeaderSlot }"
      )
        slot
</template>

<script>
export default {
  props: {
    center: {
      type: Boolean,
      required: false,
      default: false,
    },
    sidebar: {
      type: Boolean,
      required: false,
      default: false,
    },
    containerClass: {
      type: [String, Object],
      required: false,
      default: "",
    },
  },
  data() {
    return {
      containerFit: {},
    };
  },
  computed: {
    hasHeaderSlot() {
      return !!this.$slots.header;
    },
    hasSubheaderSlot() {
      return !!this.$slots.subheader;
    },
    minHeight() {
      return (
        this.$vuetify.breakpoint.height -
        this.$vuetify.application.top -
        (this.isMobile ? 84 : 50)
      );
    },
  },
  mounted() {
    this.getScrollBar();
  },
  methods: {
    getScrollBar() {
      const scrollbarWidth =
        document.getElementById("scroller")?.offsetWidth -
        document.getElementById("scroller").clientWidth;
      this.containerFit = {
        transform: `translateX(${scrollbarWidth / 2}px)`,
        "-webkit-transform": `translateX(${scrollbarWidth / 2}px)`,
        "-moz-transform": `translateX(${scrollbarWidth / 2}px)`,
        "-ms-transform": `translateX(${scrollbarWidth / 2}px)`,
        "-o-transform": `translateX(${scrollbarWidth / 2}px)`,
      };
    },
    onResize() {
      this.getScrollBar();
    },
  },
};
</script>
