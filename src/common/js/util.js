import { match } from "minimatch";
const onchange = function(value, id, column, data, idType) {
    let newData = [...data];
    console.log(newData, id, column, idType)

    let target = newData.filter(item => id === item.idType)[0];
    console.log(target);
    if (target) {
        if (column === "sStatus") {
            if (value == 1) {
                value = 0;
            } else {
                value = 1;
            }
        }
        target[column] = value;

        target.editable = true;
        // console.log(target);
        data = newData;
    } else {
        data = data;
    }
    return data;
}

const setContextData = function(key, value) {
    if (typeof value == "string") {
        sessionStorage.setItem(key, value);
    } else {
        sessionStorage.setItem(key, JSON.stringify(value));
    }
}

// 从sessionStorage取值
const getContextData = function(key) {
    const str = sessionStorage.getItem(key);
    if (typeof str == "string") {
        try {
            return JSON.parse(str);
        } catch (e) {
            return str;
        }
    }
    return;
}

const removeContextData = function(key) {
    const str = sessionStorage.removeItem(key);
    if (typeof str == "string") {
        try {
            return JSON.parse(str);
        } catch (e) {
            return str;
        }
    }
    return;
}

export {
    onchange,
    setContextData,
    getContextData,
    removeContextData
}