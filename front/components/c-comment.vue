<template lang="pug">
div
  v-card.pa-2(
    color="#f3fdf9",
    flat,
    @click.stop="toggleThanks(true)",
    type="submit"
  )
    v-row
      v-col(cols="auto")
        v-icon mdi-account
      v-col
        .text-overline.font-weight-bold.darkgray--text ユーザーからのお礼コメント
        .text-body-2.gray--text {{ staff.thank[0].body }}

  v-expand-transition
    div(v-show="staff.show")
      .py-2.text-body-2.font-weight-regular.primary--text.text-right(
        v-if="staff.thank.length > 1",
        @click.stop="toggleThanks(false)",
        type="submit"
      ) 
        | 閉じる
        v-icon(color="primary") mdi-chevron-up
      v-card.pa-2(
        color="#f3fdf9",
        flat,
        v-for="(thank, index) in staff.thank",
        :key="index",
        v-show="index !== 0"
      )
        v-row
          v-col(cols="auto")
            v-icon mdi-account
          v-col
            .text-overline.font-weight-bold.darkgray--text ユーザーからのお礼コメント
            .text-body-2.gray--text {{ thank.body }}
</template>

<script>
export default {
  props: {
    staff: {
      type: Object,
      required: false,
      default: () => {},
    },
    staffs: {
      type: Array,
      required: false,
      default: () => [],
    },
  },
  methods: {
    toggleThanks(val) {
      this.$emit("toggleThanks", val);
    },
  },
};
</script>

<style></style>
