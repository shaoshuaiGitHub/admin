import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './ant-ui.js'
import axios from 'axios'
import "./assets/iconfont/iconfont.css";

axios.defaults.withCredentials = true
Vue.prototype.axios = axios

Vue.config.productionTip = false

new Vue({
    store,
    router,
    render: h => h(App),
}).$mount('#app')