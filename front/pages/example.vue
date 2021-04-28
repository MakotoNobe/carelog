<template lang="pug">
v-container
  v-row
    v-col(cols="12")
      v-divider
    v-col(cols="12")
      div Small button (36px)
      .py-2
      v-btn(color="bluegray", small, outlined, depressed)
        span.gray--text Button
      .py-2
      v-btn(color="primary", small, depressed) Button
    v-col(cols="12")
      v-divider
    v-col(cols="12")
      div Default button (40px)
      .py-2
      v-btn(color="bluegray", outlined, depressed)
        span.primary--text Button
      .py-2
      v-btn(color="primary", depressed) Submit
    v-col(cols="12")
      v-divider
    v-col(cols="12")
      div Large button (48px)
      .py-2
      v-btn(color="primary", large, outlined, depressed) Button
      .py-2
      v-btn(color="primary", large, depressed) Submit
    v-col(cols="12")
      v-divider
    v-col(cols="12")
      v-card(width="300", elevation="12")
        v-card-text.pa-3
          div x-large button (60px)
          .py-2
          v-btn(color="bluegray", x-large, outlined, depressed, width="50%")
            span.gray--text Danang
          .py-2
          v-btn(color="primary", x-large, depressed, block) Submit
    v-col(cols="12")
      v-card(width="300", elevation="12")
        v-card-text.pa-3
          h2.text-h2 H2 heading
          h3.darkgray--text Dark gray text
            .py-2
          h3.gray--text Gray text
            .py-2
          h3.midgray--text Mid gray text
            .py-2
          h3.bluegray--text Blue gray text
            .py-2
          h3.accent--text Accent text
            .py-2
          h3.info--text Info text
            .py-2
          h3.error--text Error text
            .py-2
</template>

<script>
export default {};
</script>

<style></style>
