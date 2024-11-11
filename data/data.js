const fs = require('fs')

let userDatas = []

let allConnectData = 0
let connectAAAData = 0
let connectGsData = 0
let lostConnectData = 0

const fileName = 'data/list.json'

function pushUserData(v) {
    //读取
    try {
        const data = fs.readFileSync(fileName,'utf8')
        const list = JSON.parse(data)
        console.log(list)
        userDatas = list.slice()
    } catch (err) {
        console.log("数据读取错误",err)
    }

    // 检查是否存在具有相同 gid 的对象
    const exists = userDatas.some(item => item.gid === v.gid);

    // 如果不存在，则添加到数组中
    if (!exists) {
        userDatas.push(v);
    }

    //写入文件
    const jsonString = JSON.stringify(userDatas.slice(),null,2)
    try {
        fs.writeFileSync(fileName,jsonString)
    }catch (err){
        console.log("数据存储错误",err)
    }
}

function getUserDatas(){
    //读取
    try {
        const data = fs.readFileSync(fileName,'utf8')
        const list = JSON.parse(data)
        userDatas = list.slice()
    } catch (err) {
        console.log("数据读取错误",err)
    }
    return userDatas
}

function removeUserDatas() {
    userDatas = []
    //写入文件
    const jsonString = JSON.stringify(userDatas.slice(),null,2)
    try {
        fs.writeFileSync(fileName,jsonString)
    }catch (err){
        console.log("数据存储错误",err)
    }
}

function setConnect(allConnectV, connectAAAV, connectGsV, lostConnectV) {
    allConnectData =allConnectV
    connectAAAData =connectAAAV
    connectGsData =connectGsV
    lostConnectData =lostConnectV
    console.log(allConnectData,
    connectAAAData,
    connectGsData,
    lostConnectData)
}

module.exports = {
    userDatas,
    getUserDatas,
    removeUserDatas,
    pushUserData,
    allConnectData,
    connectAAAData,
    connectGsData,
    lostConnectData,
    setConnect
}
