<template lang="pug">
div.loading(v-show="$store.state.loading")
  v-progress-circular(:size="150" :width="15" color="blue-grey darken-3" indeterminate)
</template>
<script>
export default { name: "Loading" };
</script>
