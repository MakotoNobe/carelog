<template lang="pug">
c-layout(center)
  .px-3(:class="{ 'py-4': isMobile }")
    v-dialog(
      v-model="dialog",
      max-width="300px",
      overlay-color="darkgray",
      :overlay-opacity="0.8",
      :persistent="loading"
    )
      template(v-slot:activator="{ on, attrs }")
        div(v-if="!thanks.length")
          h1.mb-1.text-h4.font-weight-bold.darkgray--text お礼投稿はまだありません
        div(v-else)
          h1.mb-1.text-h4.font-weight-bold.darkgray--text お礼投稿履歴
          v-row
            v-col(
              v-for="(thank, index) in thanks",
              :key="index",
              cols="12",
              md="6"
            )
              v-card.pa-3
                .text-h4.font-weight-bold.darkgray--text {{ thank.staff.office.name }}
                v-list-item.px-0.py-1
                  v-list-item-avatar(size="40")
                    v-img(
                      :src="thank.staff.image || '/images/default.png'",
                      @error="thank.staff.image = '/images/default.png'"
                    )
                  v-list-item-content
                    v-list-item-title.text-subtitle-2.font-weight-bold.darkgray--text {{ thank.staff.name }} さんへのお礼
                v-divider
                v-row
                  v-col.text-body-1.font-weight-bold.gray--text.pb-2 お礼内容
                  v-col.text-body-2.gray--text.text-right.pb-2 {{ $moment(thank.created_at).format('YYYY年MM月DD日 HH:mm') }}
                .text-subtitle-2.font-weight-regular.darkgray--text.mb-2 {{ thank.body }}
                c-row(xsmall)
                  v-col(cols="4")
                    v-btn(
                      color="bluegray",
                      text,
                      v-bind="attrs",
                      outlined,
                      v-on="on",
                      block,
                      @click="deleteId = index"
                    )
                      span.primary--text 削除
                  v-col(cols="8")
                    v-btn(
                      color="primary",
                      block,
                      depressed,
                      @click="editThank(index)"
                    ) お礼を編集する
      v-card
        v-card-text.pt-10.pb-4.text-h6.text-center 削除しますか？
        v-row
          v-col(cols="5")
            v-btn(
              outlined,
              color="bluegray",
              depressed,
              block,
              @click="dialog = false",
              :loading="loading"
            )
              span.text-subtitle-2.font-weight-bold.primary--text キャンセル
          v-col(cols="7")
            v-btn(
              color="primary",
              @click="deleteThank",
              block,
              depressed,
              :loading="loading"
            ) 
              span.text-subtitle-2.font-weight-bold 削除する
</template>

<script>
export default {
  data() {
    return {
      dialog: false,
      thanks: [],
      deleteId: "",
      loading: false,
    };
  },
  async mounted() {
    const res = await this.$axios.get("/api/v1/users/thanks");
    this.thanks = res.data;
  },
  methods: {
    async deleteThank() {
      this.loading = true;
      const index = this.deleteId;
      await this.$axios.delete(
        `/api/users/thanks?thank_id=${this.thanks[index].id}`
      );
      this.thanks.splice(index, 1);
      this.deleteId = "";
      this.dialog = false;
      this.loading = false;
    },
    editThank(index) {
      this.$store.dispatch("editThankStore", {
        officeName: this.thanks[index].staff.office.name,
        officeId: this.thanks[index].staff.office_id,
        editIndex: this.thanks[index].id,
        targetStaff: this.thanks[index].staff.name,
        thankBody: this.thanks[index].body,
      });
    },
  },
};
</script>
