let userDatas = []

let allConnectData = 0
let connectAAAData = 0
let connectGsData = 0
let lostConnectData = 0

function pushUserData(v) {
    // 检查是否存在具有相同 gid 的对象
    const exists = userDatas.some(item => item.gid === v.gid);

    // 如果不存在，则添加到数组中
    if (!exists) {
        userDatas.push(v);
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
    pushUserData,
    allConnectData,
    connectAAAData,
    connectGsData,
    lostConnectData,
    setConnect
}
