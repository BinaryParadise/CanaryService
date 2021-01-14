import crypto from 'crypto'

Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月份
        "d+": this.getDate(), //日
        "H+": this.getHours(), //小时
        "m+": this.getMinutes(), //分
        "s+": this.getSeconds(), //秒
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度
        "S": this.getMilliseconds() //毫秒
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? ("000" + o[k]).substr(("" + o[k]).length) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
}

export function routerURL(url, record) {
    return {
        pathname: `${url}`,
        state: record
    }
}

export function MD5(str) {
    const hash = crypto.createHash('md5');
    return hash.update(str).digest('hex');
}

export function AuthUser() {
    let user = JSON.parse(localStorage.getItem("user"));
    if (user == null || user == undefined) {
        return { level: 9 };
    }
    return user;
}

export function Auth(item) {
    const user = AuthUser();
    if (item === 'user') {
        return user.rolelevel == 0;
    } else if (item === 'project') {
        return user.rolelevel <= 1;
    }
    return false;
}

export const MessageType = {
    Connected: 1,
    Update: 2,
    Register: 10,
    DeviceList: 11,
    DBQuery: 20,  //unsupport
    DBResult: 21, //unsupport
    Logger: 30
  }