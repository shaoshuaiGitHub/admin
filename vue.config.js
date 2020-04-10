const path = require('path')

function resolve(dir) {
    return path.join(__dirname, dir)
}
module.exports = {
    publicPath: './',
    productionSourceMap: false,
    assetsDir: 'static', // 设置输出目录
    css: {},
    chainWebpack(config) {
        config.resolve.alias
            .set('api', resolve('src/api'))
    }
}