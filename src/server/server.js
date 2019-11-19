const http = require('http');
// 导入WebSocket模块:
const WebSocket = require('ws');

// 实例化:
const wss = new WebSocket.Server({port:8081});

//服务端广播消息
wss.broadcast=function broadcast(message) {
  wss.clients.forEach(function each (client) {
    if(client.isWeb && client.readyState == WebSocket.OPEN){
      client.send(message);
    }
  })
}

wss.on('connection', function (ws, request) {
    console.log(`[SERVER] connection(`+request.url+`)`);
    ws.isWeb = request.url.indexOf('/device/') == -1
    if (!ws.isWeb) {
      ws.on('message', function (message) {
          // console.log(`[SERVER] Received: ${message}`);
          wss.broadcast(message)
      })
    }
});

console.log('ws server started at port '+wss.options.port+'...');
