import axios from 'axios'
import router from '../router'
import qs from 'qs'
import { message } from 'ant-design-vue'

const urlMap = {
    development: 'http://110.83.28.113:28000', // 开发
    production: 'http://110.83.28.113:28000' // 生产
}

const baseUrl = urlMap[process.env.NODE_ENV]
const ERR_OK = 1
const ERR_HAS = 11111
const ERR_EXPIRED = 10002

// http request 拦截器
axios.interceptors.request.use(
    config => {
        let data = qs.parse(config.data)
        if (config.method === 'post' && config.headers['Content-Type'] != 'application/json;charset=UTF-8' && config.headers['Content-Type'] != 'multipart/form-data;charset=utf-8' && config.headers['Content-Type'] != 'form-data;charset=utf-8') {
            config.data = qs.stringify({
                ...data
            })
        } else if (config.method === 'get') {
            config.params = {
                ...config.params
            }
        } else if (config.method === 'put' && config.headers['Content-Type'] != 'application/json;charset=UTF-8') {
            config.data = qs.stringify({
                ...data
            })
        } else if (config.method === 'delete') {
            config.data = qs.stringify({
                ...data
            })
        }
        return config
    },
    error => {
        return Promise.reject(error)
    }
)

// http response 拦截器
axios.interceptors.response.use((data) => {
    const { code, msg } = data.data
        // eslint-disable-next-line no-console
        // console.log(code, msg)

    if (code != ERR_OK && code != ERR_EXPIRED && code != ERR_HAS) {
        message.success(msg)
        return false
    }
    if (code === ERR_EXPIRED) {
        message.success(msg)
        localStorage.removeItem('userinfo')
        localStorage.removeItem('usermenu')
        router.replace('/login')
        return false
    }
    if (code === ERR_OK || code === ERR_HAS) {
        return data.data
    }

}, (error) => {
    return Promise.reject(error)
})

export function get(url) {
    return function(params = {}) {
        return axios({
            method: 'get',
            url: baseUrl + url,
            params: params
        })
    }
}
export function _get(url) {
    return function(params = {}) {
        const newUrl = url + '/' + params.paramsId;
        delete params.paramsId;
        return axios({
            method: 'get',
            url: baseUrl + newUrl,
            params: params,
        })
    }
}
export function _delete(url) {
    return function(data = {}) {
        return axios({
            method: 'delete',
            url: baseUrl + url,
            data: { data: data }
        })
    }
}
export function _deleteID(url) {
    return function(data = {}) {
        const newUrl = url + '/' + data.paramsId;
        delete data.paramsId;
        return axios({
            method: 'delete',
            url: baseUrl + newUrl,
            data: { data: data }
        })
    }
}

export function post(url, headers = {}) {
    return function(data = {}) {
        return axios({
            method: 'post',
            url: baseUrl + url,
            data: data,
            headers: headers
        })
    }
}
export function put(url, headers = {}) {
    return function(data = {}) {
        return axios({
            method: 'put',
            url: baseUrl + url,
            data: data,
            headers: headers
        })
    }
}

export function _put(url, headers = {}) {
    return function(data = {}) {
        const newUrl = url + '/' + data.paramsId;
        delete data.paramsId;
        return axios({
            method: 'put',
            url: baseUrl + newUrl,
            data: data,
            headers: headers
        })
    }
}