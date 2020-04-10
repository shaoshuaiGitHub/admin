// 带T的日期
export function getTdata(data) {
    if (!(data === null)) {
        return (new Date(data * 1000)).toLocaleDateString().match(/((?!\D).)+/g).join('-')
            // let retdata = data.split('T')
            // return retdata[0]
    }
}

function formatNumber(n) {
    n = n.toString()
    return n[1] ? n : '0' + n
}
/**
 * paranem formatTime(time, 'Y-M-D') formatTime(1545903266795, 'Y年M月D日 h:m:s')  或者formatTime(1545903266795, 'Y-M-D h:m:s')
 */
export function formatTime(number, format) {
    let time = new Date(number * 1000)
    let newArr = []
    let formatArr = ['Y', 'M', 'D', 'h', 'm', 's']
    newArr.push(time.getFullYear())
    newArr.push(formatNumber(time.getMonth() + 1))

    newArr.push(formatNumber(time.getDate()))

    newArr.push(formatNumber(time.getHours()))
    newArr.push(formatNumber(time.getMinutes()))
    newArr.push(formatNumber(time.getSeconds()))

    for (let i in newArr) {
        format = format.replace(formatArr[i], newArr[i])
    }
    return format
}