export default {
  messagers: [],
  create: function(deviceid) {
    if (this.sock !== undefined) {
      return this;
    }
    this.url = 'ws://'+window.location.hostname + ':8082/fk/web/'+deviceid
    var context = this
    this.onOpen = () => {
      console.info('[WS]onopen：', context.url)
      context.onMessage({code:0, type: 1, msg: '连接成功!'})
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
  addReceiver: function(onMessage) {
    if (onMessage !== undefined && this.messagers.indexOf(onMessage) < 0) {
      this.messagers.push(onMessage)
    }
    return this;
  },
  connect: function(onMessage) {
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
          setTimeout(function() {
            context.connect.apply(context)
          }, 10000)
        }
      }
      sock.onclose = e => {
        if (e.type === 'error' || e.type === 'close') {
          context.connect()
        }
      }
      this.sock = sock
    }
  },
  onMessage: function(obj) {
    for (let messager of this.messagers) {
      if (messager(obj)) {
        break
      }
    }
  }
}
