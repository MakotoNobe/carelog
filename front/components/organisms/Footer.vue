<template>
  <div class="footer">
      <div class="logo">
        <a href="/" aria-current="page">
          <b>ホームケアナビ</b>
        </a>
      </div>
      <div class="logo" id="copy">©️hogehoge</div>
      <ul class="nav">
        <li><a href="/privacy_policy">プライバシーポリシー</a></li>
        <li><a href="/terms">利用規約</a></li>
        <li><a href="/contact"> お問い合わせ</a></li>
      </ul>
    </div>
</template>
<script>
export default {
  name: "Footer",
};
</script>
<style>
.footer {
  bottom: 0;
  width: 100%;
  margin-bottom: auto;
  background-color: #fff;
}

.logo {
  display: inline-block;
  margin-left: auto;
}

.logo a {
  text-decoration: none;
  padding-left: 200px;
  display: inline-block;
  margin-bottom: 10px;
  cursor: pointer;
}

#copy {
  font-size: 10px;
  padding-left: 20px;
  color: gray;
  padding-top: 4px;
}

.nav li a {
  color: red;
  text-decoration: none;
}

.nav li {
  display: inline-block;
  font-size: 12px;
  margin-left: 10px;
  padding-right: 15px;
  justify-content: space-between;
  cursor: pointer;
}

.nav {
  text-align: right;
  padding-right: 145px;
  margin-bottom: 10px;
}
</style>
