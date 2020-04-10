<template>
  <a-locale-provider :locale="zh_CN">
    <div id="app">
      <router-view v-if="isRouterAlive" />
    </div>
  </a-locale-provider>
</template>

<script>
import zh_CN from 'ant-design-vue/lib/locale-provider/zh_CN'
import moment from 'moment'
import 'moment/locale/zh-cn'
moment.locale('zh-cn')
export default {
  beforeRouteUpdate () {
  },
  provide(){
    return {
      reload: this.reload
    }
  },
  data() {
    return {
      zh_CN,
      isRouterAlive:true,
    }
  },
  name: 'app',
  components: {},
  methods:{
    reload () {
      this.isRouterAlive = false;
      this.$nextTick(function () {
        this.isRouterAlive = true;
      })
    }
  }
}
</script>

<style>
body,
div,
dl,
dt,
dd,
ul,
ol,
li,
h1,
h2,
h3,
h4,
h5,
h6,
pre,
code,
form,
fieldset,
legend,
input,
textarea,
p,
blockquote,
th,
td,
hr,
button,
article,
aside,
details,
figcaption,
figure,
footer,
header,
hgroup,
menu,
nav,
section {
  margin: 0;
  padding: 0;
}
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  height: 100%;
}
.ant-pro-grid-content {
  width: 100%;
  height: 100%;
  min-height: 100%;
  transition: 0.3s;
}
.ant-page-header {
  box-sizing: border-box;
  margin: 0;
  color: rgba(0, 0, 0, 0.65);
  font-size: 14px;
  font-variant: tabular-nums;
  line-height: 1.5;
  list-style: none;
  font-feature-settings: "tnum";
  position: relative;
  padding: 16px 24px;
  background: #fff;
}
.wrap-children-content {
  margin: 24px 24px 0;
}
.pages-list-table-list {
  margin-bottom: 16px;
}
.ant-breadcrumb + .ant-page-header-heading {
  margin-top: 12px;
}
.ant-page-header-heading-title {
  display: inline-block;
  padding-right: 12px;
  color: rgba(0, 0, 0, 0.85);
  font-weight: 700;
  font-size: 16px;
  line-height: 1.4;
}
</style>
