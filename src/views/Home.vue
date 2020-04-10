<template>
  <a-layout id="components-layout-demo-side" style="min-height: 100vh">
    <!-- 左边导航 -->
    <a-layout-sider
      class="sider"
      :trigger="null"
      collapsible
      v-model="collapsed"
      theme="dark"
      width="256"
      v-if="screenWidth > 500"
    >
      <div class="logo" @click="jumpHomePage">
        <img src="../assets/logo.png" :style="{height:'32px',width:'32px'}" />
        <h1 v-if="!collapsed">期望管家平台</h1>
      </div>
      <a-menu
        theme="dark"
        mode="inline"
        :openKeys="openKeys"
        :selectedKeys="selectedKeys"
        :inlineCollapsed="collapsed"
        @openChange="handleOpenChange"
        @click="swithRouter"
      >
        <template v-for="item in menuList">
          <a-menu-item v-if="!item.children" :key="item.key">
            <template v-if="collapsed">
              <a-icon :type="item.icon" v-if="item.icon" />
            </template>
            <template v-else>
              <a-icon :type="item.icon" v-if="item.icon" />
              <span>{{item.title}}</span>
            </template>
          </a-menu-item>
          <sub-menu v-else :menu-info="item" :key="item.key" />
        </template>
      </a-menu>
    </a-layout-sider>
    <a-drawer
      placement="left"
      :closable="false"
      :visible="collapsed"
      @close="onClose"
      :style="{padding:'0'}"
      v-else
    >
      <!-- <div class="logo" @click="jumpHomePage">
        <img src="../assets/logo.png" :style="{height:'32px',width:'32px'}" />
        <h1 v-if="!collapsed">期望管家平台</h1>
      </div>-->
      <a-menu
        class="dra-menu"
        theme="dark"
        mode="inline"
        :openKeys="openKeys"
        :selectedKeys="selectedKeys"
        @openChange="handleOpenChange"
        @click="swithRouter"
      >
        <template v-for="item in menuList">
          <a-menu-item v-if="!item.children" :key="item.key">
            <template v-if="collapsed">
              <a-icon :type="item.icon" v-if="item.icon" />
            </template>
            <template v-else>
              <a-icon :type="item.icon" v-if="item.icon" />
              <span>{{item.title}}</span>
            </template>
          </a-menu-item>
          <sub-menu v-else :menu-info="item" :key="item.key" />
        </template>
      </a-menu>
    </a-drawer>
    <a-layout>
      <!-- 顶部导航 -->
      <a-layout-header class="a-layout-header-box">
        <a-icon
          class="trigger"
          :type="collapsed? 'menu-unfold' : 'menu-fold'"
          @click="toggleCollapsed"
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
            <a-menu slot="overlay" class="dropdown-slect-menu">
              <a-menu-item @click="userSet">
                <a-icon type="setting" />
                <span>用户设置</span>
              </a-menu-item>
              <a-menu-divider />
              <a-menu-item @click="_loginOut">
                <a-icon type="logout" />
                <span>退出</span>
              </a-menu-item>
            </a-menu>
          </a-dropdown>
        </div>
      </a-layout-header>
      <!-- 内容 -->
      <a-layout-content :style="{ height: '100%', margin: '10px 24px 0'}">
        <home-page />
        <transition name="slide-fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </a-layout-content>
      <a-layout-footer style="text-align: center">QiWangGuanJia ©2020 Created by LuKe</a-layout-footer>
    </a-layout>
  </a-layout>
</template>

<script>
import Menu from "../components/Menu";
import HomePage from "./HomePage";
import { loginOut } from "api";
import { mapMutations, mapGetters } from "vuex";

export default {
  name: "Home",
  props: {
    msg: String
  },
  components: {
    "sub-menu": Menu,
    "home-page": HomePage
  },
  data() {
    return {
      urlMap: new Map(),
      collapsed: false,
      userdata: [],
      openKeys: this.$route.meta.parentkey || [],
      selectedKeys: this.$route.meta.key,
      menuList: [],
      rootSubmenuKeys: [],
      isKeepAlive: this.$route.meta.keepAlive,
      screenWidth: document.body.clientWidth
    };
  },

  computed: {
    ...mapGetters(["get_userinfo", "get_usermenu"])
  },
  watch: {
    screenWidth(val) {
      // 为了避免频繁触发resize函数导致页面卡顿，使用定时器
      if (!this.timer) {
        // 一旦监听到的screenWidth值改变，就将其重新赋给data里的screenWidth
        this.screenWidth = val;
        this.timer = true;
        let that = this;
        setTimeout(function() {
          // screenWidth变化的值
          that.collapsed = that.screenWidth < 1200 ? true : false;
          that.timer = false;
        }, 400);
      }
    },

    get_userinfo() {
      this.userdata = this.get_userinfo;
    },
    get_usermenu() {
      this.menuList = this.get_usermenu;
    }
    // $route() {
    //   this.openKeys = this.$route.meta.parentkey;
  },
  mounted() {
    this.initUrlMap(this.menuList);
    const that = this;
    window.onresize = () => {
      return (() => {
        window.screenWidth = document.body.clientWidth;
        that.screenWidth = window.screenWidth;
      })();
    };
  },
  created() {
    this._getuserinfo();
  },
  methods: {
    onClose() {
      this.collapsed = false;
    },
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
      this.rootSubmenuKeys = numlist.map(item => {
        return (item = item.key);
      });
    },
    toggleCollapsed() {
      this.collapsed = !this.collapsed;
    },
    handleOpenChange(openKeys) {
      const latestOpenKey = openKeys.find(
        key => this.openKeys.indexOf(key) === -1
      );
      if (this.rootSubmenuKeys.indexOf(latestOpenKey) === -1) {
        this.openKeys = openKeys;
      } else {
        this.openKeys = latestOpenKey ? [latestOpenKey] : [];
      }
    },
    // 跳转页面 {item, key, keyPath }
    swithRouter({ key }) {
      let url = this.urlMap.get(key);
      this.selectedKeys = [key];
      url && this.$router.push(url);
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
    },
    userSet() {
      this.$router.push({
        path: "/system/admin",
        name: "systemAdmin"
      });
    },
    jumpHomePage() {
      this.$router.push({
        name: "home"
      });
    }
  }
};
</script>


<style scoped>
/* @media screen and (min-width: ){
  
} */
.a-layout-header-box {
  background: #fff;
  padding: 0 12px 0 0;
  -webkit-box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  position: relative;
  top: 0;
  right: 0;
  z-index: 2;
}

.ai-header-right {
  float: right;
  height: 100%;
}
.sider {
  min-height: 100vh;
  -webkit-box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);
  box-shadow: 2px 0 6px rgba(0, 21, 41, 0.35);
  position: relative;
  z-index: 10;
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
  color: #fabd54;
  font-size: 22px;
  margin: 3px 0 0 12px;
  font-family: Avenir, Helvetica Neue, Arial, Helvetica, sans-serif;
  font-weight: 600;
  vertical-align: middle;
  letter-spacing: 4px;
}
#components-layout-demo-side .trigger {
  font-size: 20px;
  line-height: 64px;
  padding: 0 24px;
  cursor: pointer;
  transition: color 0.3s;
  color: rgb(99, 99, 99);
}

#components-layout-demo-side .trigger:hover {
  color: #1890ff;
}
.dropdown-slect-menu {
  margin: 21px 0 0 0;
  padding: 4px 0;
}
</style>
