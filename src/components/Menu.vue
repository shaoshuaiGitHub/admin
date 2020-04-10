<template functional>
  <a-sub-menu :key="props.menuInfo.key">
    <span slot="title">
      <svg class="icon" aria-hidden="true" v-if="props.menuInfo.icon">
        <use :xlink:href="'#'+props.menuInfo.icon" />
      </svg>
      <!-- <span :class="[{'iconfont':'iconfont'},props.menuInfo.icon]"  v-if="props.menuInfo.icon"></span> -->
      <span>{{props.menuInfo.title}}</span>
    </span>
    <template v-for="item in props.menuInfo.children">
      <a-menu-item v-if="!item.children" :key="item.key">
        <svg class="icon" aria-hidden="true" v-if="item.icon">
          <use :xlink:href="'#'+item.icon" />
        </svg>
        <span>{{item.title}}</span>
      </a-menu-item>
      <sub-menu v-else :menu-info="item" :key="item.key" />
    </template>
  </a-sub-menu>
</template>

<script>
import iconFont from "../assets/iconfont/iconfont.js";

export default {
  props: ["menuInfo"],
  data() {
    return {};
  },
};
</script>
<style>
/* @import"../assets/iconfont/iconfont.css"; */
.icon {
  width: 1.2em;
  height: 1.2em;
  vertical-align: -0.15em;
  fill: currentColor;
  overflow: hidden;
  margin-right: 10px;
}
</style>
