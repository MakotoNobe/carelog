<template lang="pug">
v-row.c-row(
  v-bind="$attrs",
  :class="{ 'c-row-xsmall': xsmall, 'c-row-small': small, 'c-row-large': large }"
)
  slot
</template>

<script>
export default {
  props: {
    xsmall: {
      type: Boolean,
      required: false,
      default: false, // small
    },
    small: {
      type: Boolean,
      required: false,
      default: false, // small
    },
    large: {
      type: Boolean,
      required: false,
      default: false, // small
    },
  },
};
</script>

<style scoped lang="scss">
.c-row {
  &.c-row-small {
    margin-right: -6px !important;
    margin-left: -6px !important;
    & > div[class^="col"] {
      padding: 6px !important;
    }
  }
  &.c-row-large {
    margin-right: -20px !important;
    margin-left: -20px !important;
    & > div[class^="col"] {
      padding: 20px !important;
    }
  }
  &.c-row-xsmall {
    margin-right: -4px !important;
    margin-left: -4px !important;
    & > div[class^="col"] {
      padding: 4px !important;
    }
  }
}
</style>
