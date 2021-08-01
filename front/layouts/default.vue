<template>
  <div>
    <Header />
    <Nuxt/>
    <Footer />
  </div>
</template>

<script>
import Header from '@/components/organisms/Header.vue';
import Footer from '@/components/organisms/Footer.vue';

export default {
  name:"default",
  components: {
    Header,
    Footer,
  },
};

</script>

<style>


</style>
