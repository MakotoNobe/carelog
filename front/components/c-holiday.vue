<template lang="pug">
v-row(align="center")
  v-col.pl-0.py-0(:cols="titleInline ? 'auto' : '12'")
    .body-1.font-weight-bold.gray--text 営業日
  .week_days.d-flex.flex-grow-1
    .week_day(v-for="(week, index) in weeks", :key="index")
      h5.title_week {{ week.name }}
      .pb-2
        span
          v-icon.icon(v-if="holidays.includes(week.slug)") mdi-close
          v-icon.icon.icon_warning(v-else="", color="warning") mdi-checkbox-blank-circle-outline
</template>
<script>
import weekDays from "@/utils/weeks.js";
export default {
  name: "CHoliday",
  props: {
    holidays: {
      type: Array,
      required: false,
      default: () => [],
    },
    titleInline: {
      type: Boolean,
      required: false,
      default: true,
    },
  },
  data() {
    return {
      weeks: weekDays.items || [],
    };
  },
};
</script>
<style lang="scss" scoped>
.sub_title {
  margin-top: 12px;
  font-size: 11px;
}

.week_days {
  justify-content: center;
  line-height: 22px;
  margin-top: 12px !important;
  .title_week {
    font-size: 11px;
    line-height: 14px;
    background: #f5f7f7;
    color: #2e3331;
    padding: 5px 10px;
  }
  .week_day {
    flex: 1;
    text-align: center;
    border: thin solid #d9dede;
    border-right: none;
  }
  .week_day:last-child {
    border-right: thin solid #d9dede;
    .title_week {
      color: #2e6ee6;
    }
  }
  .week_day:first-child {
    .title_week {
      color: #e23e5d;
    }
  }
  .icon {
    font-size: 16px;
  }
  .icon_warning {
    color: #aeb5b2;
  }
}
</style>
