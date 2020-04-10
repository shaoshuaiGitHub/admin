<template>
  <a-layout id="components-layout-demo-side" style="min-height: 100vh">
    <!-- 左边导航 -->
    <a-layout-sider class="sider" :trigger="null" collapsible v-model="collapsed" theme="dark" width="256px">
      <div class="logo">
        <img src="../assets/logo.png" :style="{height:'32px',width:'32px'}" alt v-if="collapsed"/>
        <template v-else>
          <img src="../assets/logo.png" :style="{height:'32px',width:'32px'}" alt/>
          <h1 >期望管家平台</h1>
        </template>
      </div>
      <a-menu
        theme="dark"
        mode="inline"
        :defaultSelectedKeys="[menuList[0].key]"
        :openKeys="openKeys"
        :selectedKeys="selectedKeys"
        :inlineCollapsed="collapsed"
        @openChange="handleOpenChange"
        @click="swithRouter"
      >
        <template v-for="item in menuList">
          <a-menu-item v-if="!item.children" :key="item.key">
            <a-icon :type="item.icon" v-if="item.icon" />
            <span>{{item.title}}</span>
          </a-menu-item>

          <sub-menu v-else :menu-info="item" :key="item.key" />
        </template>
      </a-menu>
    </a-layout-sider>
    <a-layout>
      <!-- 顶部导航 -->
      <a-layout-header
        style="background: #fff; padding: 0 12px 0 0;-webkit-box-shadow: 0 1px 4px rgba(0,21,41,.08);
    box-shadow: 0 1px 4px rgba(0,21,41,.08);
    position: relative;z-index: 2;"
      >
        <a-icon
          class="trigger"
          :type="collapsed ? 'menu-unfold' : 'menu-fold'"
          @click="()=> collapsed = !collapsed"
        />
        <div class="ai-header-right">
          <a-dropdown>
            <a class="ant-dropdown-link" href="#">
              <a-avatar
                size="small"
                src="https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png"
              />
              {{userdata.userName}}
            </a>
            <a-menu slot="overlay">
              <a-menu-item>
                <a href="javascript:;" @click="_loginOut">退出</a>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </div>
      </a-layout-header>
      <!-- 内容 -->
      <a-layout-content :style="{  margin: '24px'}">
        <transition name="slide-fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </a-layout-content>
      <a-layout-footer style="text-align: center">nodecms ©2019 Created by YU UED</a-layout-footer>
    </a-layout>
  </a-layout>
</template>

<script>
import Menu from "../components/Menu";
import { loginOut } from "api";
import { mapMutations, mapGetters } from "vuex";

export default {
  name: "Home",
  props: {
    msg: String
  },
  components: {
    "sub-menu": Menu
  },
  data() {
    return {
      urlMap: new Map(),
      collapsed: false,
      userdata: [],
      openKeys: this.$route.meta.parentkey,
      selectedKeys: this.$route.meta.key,
      menuList: []
    };
  },
  computed: {
    ...mapGetters(["get_userinfo", "get_usermenu"])
  },
  watch: {
    get_userinfo() {
      this.userdata = this.get_userinfo;
    },
    get_usermenu() {
      this.menuList = this.get_usermenu;
    },
    $route() {
      this.openKeys = this.$route.meta.parentkey;
    }
  },
  created() {
    this._getuserinfo();
  },
  methods: {
    ...mapMutations(["set_removeItem"]),
    _loginOut() {
      loginOut().then(res => {
        if (res.code) {
          this.$store.dispatch("set_removeItemFun", "usermenu");
          this.$store.dispatch("set_removeItemFun", "userinfo");
          this.$router.replace("/login");
        }
      });
    },
    _getuserinfo() {
      let userds = JSON.parse(window.localStorage.getItem("userinfo") || null);
      let numlist = JSON.parse(window.localStorage.getItem("usermenu") || null);
      if (numlist && userds) {
        this.userdata = userds;
        this.menuList = numlist;
      }
      console.log(numlist);
    },
    toggleCollapsed() {
      this.collapsed = !this.collapsed;
    },
    handleOpenChange(openKeys) {
      let keys;
      if (openKeys.length > 1) {
        if (openKeys.length > 2) {
          keys = [openKeys[openKeys.length - 1]];
        } else if (openKeys[1].indexOf(openKeys[0]) > -1) {
          keys = [openKeys[0], openKeys[1]];
        } else {
          keys = [openKeys[openKeys.length - 1]];
        }
        this.openKeys = keys;
      } else {
        this.openKeys = openKeys;
      }
    },
    // 跳转页面 {item, key, keyPath }
    swithRouter({ key }) {
      let url = this.urlMap.get(key);
      url && this.$router.push(url);
      this.selectedKeys = this.$route.meta.key;
    },
    // 初始化urlMap对象 (menu, index)
    initUrlMap(menuList) {
      let self = this;
      menuList.forEach(menu => {
        if (menu.children) {
          self.initUrlMap(menu.children);
        } else if (menu.url) {
          this.urlMap.set(menu.key, menu.url, menu.title);
        }
      });
    }
  },
  mounted() {
    this.initUrlMap(this.menuList);
  }
};
</script>


<style scoped>
.sider {
  min-height: 100vh;
  -webkit-box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);
  box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);
  position: relative;
  z-index: 10;
}
.ai-header-right {
  float: right;
  height: 100%;
}
#components-layout-demo-side .logo {
  position: relative;
  height: 64px;
  padding-left: 24px;
  overflow: hidden;
  line-height: 64px;
  background: #002140;
  -webkit-transition: all 0.3s;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  margin-bottom: 15px;
}
.logo h1 {
  color: #fff;
  font-size: 20px;
  margin: 0 0 0 12px;
  font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
  font-weight: 600;
  vertical-align: middle;
}
#components-layout-demo-side .trigger {
  font-size: 18px;
  line-height: 64px;
  padding: 0 24px;
  cursor: pointer;
  transition: color 0.3s;
}

#components-layout-demo-side .trigger:hover {
  color: #1890ff;
}
</style>
