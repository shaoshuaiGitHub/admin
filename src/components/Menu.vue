<template functional>
  <a-sub-menu :key="props.menuInfo.key" >
    <span slot="title">
      <!-- <svg class="icon" aria-hidden="true" v-if="props.menuInfo.icon">
        <use :xlink:href="'#'+props.menuInfo.icon" />
      </svg> -->
      <a-icon class="icon" :type="props.menuInfo.icon.split(',')[0]" theme="twoTone"  :twoToneColor="props.menuInfo.icon.split(',')[1]" v-if="props.menuInfo.icon"/>
      <span>{{props.menuInfo.title}}</span>
    </span>
    <template v-for="item in props.menuInfo.children">
      <a-menu-item v-if="!item.children" :key="item.key">
        <!-- <svg class="icon" aria-hidden="true" v-if="item.icon">
          <use :xlink:href="'#'+item.icon" />
        </svg> -->
        <a-icon class="icon" :type="item.icon" v-if="item.icon"/>
        <span>{{item.title}}</span>
      </a-menu-item>
      <sub-menu v-else :menu-info="item" :key="item.key" />
    </template>
  </a-sub-menu>
</template>

<script>
// import iconFont from "../assets/iconfont/iconfont.js";
export default {
  props: ["menuInfo"],
  data() {
    return {
    };
  }
};
</script>
<style>
/* @import"../assets/iconfont/iconfont.css"; */

/* .icon {
  width: 1em;
  height: 1em;
  vertical-align: -0.15em;
  fill: currentColor;
  overflow: hidden;
  margin-right: 10px;
} */
</style>
