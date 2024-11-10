var spawn = require('child_process').spawn


var lua_exe_path
var file_name
function readLuaTable(luaFile, cb) {
    var atmPath
    var runLua = spawn(lua_exe_path, ['-lCHS', 'table2json.lua', luaFile]);
    var str = "";

    runLua.stdout.on('data', function(data) {
        str += data;
    });

    runLua.stderr.on('data', function(data) {
        console.log('error: ' + data);
    });

    runLua.on('close', function(code) {
        if (code == 0) {
            cb(JSON.parse(str));
        } else {
            console.log('error: lua exe exit code=' + code);
        }
    });
}

// 返回缩进空格数
getSpace = function(index) {
    var num = index * 4
    return Array(num).join(" ");
}

getValueStr = function(value){
    var tmp = value * 1 // 转为整形
    var tem2 = value.replace(" ", "")
    if (tmp || (tmp == 0 && tem2 != "")){
        // 整形
        return value
    } else if (value == "true" || value == "false") {
        // bool
        return value
    } else{
        // 字符串
        return "'" + value + "'"
    }
}

// 递归打印
convertTojs = function(res, index){
    if (res == null) {
        return;
    }

    for (var key in res){
        if (typeof(res[key]) == "object") {
            console.log("%s%s : {", getSpace(index), getValueStr(key))

            convertTojs(res[key], index + 1)

            console.log("%s},", getSpace(index))
        } else if (typeof(res[key]) == "function") {
        } else if (typeof(res[key]) == "undefined") {
        } else {
            console.log("%s%s : %s,", getSpace(index), getValueStr(key), getValueStr(res[key]))
        }
    }
}

main = function(){
    readLuaTable(file_name, function(res){
        console.log("module.exports = {")
        convertTojs(res, 1)
        console.log("};")
    })
}

if (null != process.argv[2]) {
    lua_exe_path = process.argv[2];
}

if (null != process.argv[3]) {
    file_name = process.argv[3];
}

if (file_name && lua_exe_path) {
    main();
}