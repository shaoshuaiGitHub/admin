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
const a = function() {
    console.log("this is a")
}

export {
    onchange,
    a
}