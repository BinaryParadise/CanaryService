import { wsPath, baseURI } from '../common/config'
import URL from 'url'

export default {
  messagers: [],
  create: function (deviceid) {
    let apiURL = URL.parse(baseURI).host ? URL.parse(baseURI) : window.location
    this.url = (apiURL.protocol == "http:" ? "ws://" : "wss://") + apiURL.hostname + (apiURL.port ? ":" + apiURL.port : "") + wsPath + '/web/' + deviceid
    var context = this
    this.onOpen = () => {
      console.info('[WS]onopen：', context.url)
      context.onMessage({ code: 0, type: 1, msg: '连接成功!' })
    }

    this.sendMessage = obj => {
      if (this.sock.readyState === 1) {
        var msg = JSON.stringify(obj)
        var utf8buf = new Buffer(msg)
        this.sock.send(utf8buf)
      }
    }

    return this
  },
  addReceiver: function (onMessage) {
    if (onMessage !== undefined && this.messagers.indexOf(onMessage) < 0) {
      this.messagers.push(onMessage)
    }
    return this;
  },
  connect: function (onMessage) {
    this.addReceiver(onMessage)
    var context = this
    if (this.sock === undefined || this.sock.readyState === 3) {
      var sock =
        WebSocket === undefined ? new window.MozWebSocket(this.url) : new WebSocket(this.url)
      sock.binaryType = 'arraybuffer'
      window.wssock = sock
      sock.onopen = this.onOpen

      sock.onmessage = event => {
        if (event.data instanceof ArrayBuffer) {
          var dataStr = Buffer.from(event.data).toString()
          var obj = JSON.parse(dataStr)
          context.onMessage(obj)
        }
      }
      sock.onerror = e => {
        console.error(e);
        if (sock.readyState === 3) {
          setTimeout(function () {
            context.connect.apply(context)
          }, 10000)
        }
      }
      sock.onclose = e => {
        if (e.code != 1000) {
          context.onMessage({ code: 1, type: 0, msg: "连接已断开，10秒稍后自动重连" })
          setTimeout(function () {
            context.connect.apply(context)
          }, 10000)
        } else {
          console.info("[WS]正常关闭")
        }
      }
      this.sock = sock
    }
  },
  close: function () {
    this.sock.close()
    this.sock = undefined
    this.messagers = []
  },
  onMessage: function (obj) {
    for (let messager of this.messagers) {
      if (messager(obj)) {
        break
      }
    }
  }
}
