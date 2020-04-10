import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)
    // namespaced: true,
const state = {
    userinfo: null,
    usermenu: null
}
const getters = {
    get_userinfo: state => {
        let userinfo = state.userinfo
        if (!userinfo) {
            userinfo = JSON.parse(window.localStorage.getItem('userinfo') || null)
        }
        return userinfo
    },
    get_usermenu: state => {
        let usermenu = state.usermenu
        if (!usermenu) {
            usermenu = JSON.parse(window.localStorage.getItem('usermenu') || null)
        }
        return usermenu
    }
}
const mutations = {
    // 设置用户信息
    set_userinfo(state, data) {
        state.userinfo = data
        localStorage.setItem('userinfo', JSON.stringify(data))
    },
    // 设置用户菜单
    set_usermenu(state, data) {
        state.tokencon = data
        localStorage.setItem('usermenu', JSON.stringify(data))
    },
    // 删除
    set_removeItem(state, data) {
        if (data === 'userinfo') {
            state.userinfo = ''
        }
        if (data === 'usermenu') {
            state.tokencon = ''
        }
        localStorage.removeItem(data)
    }
}

const actions = {
    set_userinfoFun(context, data) {
        context.commit('set_userinfo', data);
    },
    set_usermenuFun(context, data) {
        context.commit('set_usermenu', data);
    },
    set_removeItemFun(context, data) {
        context.commit('set_removeItem', data);
    }
}

export default new Vuex.Store({
    getters,
    state,
    mutations,
    actions
})