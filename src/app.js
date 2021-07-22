// 导入WebSocket模块:
// const { WebSocket } = require('ws');
// const sqlite3 = require('sqlite3')

const xxx = process.env
window.__config__ = {
  env: xxx,
  user: JSON.parse(localStorage.getItem('user'))
}

/*
var serverPort = 8082;

// 实例化:
const wss = new WebSocket.Server({ port: serverPort });

//服务端广播消息
wss.broadcast = function broadcast(message) {
  wss.clients.forEach(function each(client) {
    if (client.isWeb && client.readyState == WebSocket.OPEN) {
      client.send(message);
    }
  })
}

wss.on('connection', function (ws, request) {
  console.log(`[SERVER] (` + request.url + `) connected`);
  ws.send(`connected`);
  ws.isWeb = request.url.indexOf('/device/') == -1
  if (!ws.isWeb) {
    ws.on('message', function (message) {
      // console.log(`[SERVER] Received: ${message}`);
      wss.broadcast(message)
    })
  }
});

wss.on('close', function (ws, request) {
  console.log(`[SERVER] (` + request.url + `) disconnected`);
});

console.log('ws server started at port ' + serverPort + '...');
*/

//打开数据库，如果没有会自动创建
// var database;
// database = new sqlite3.Database("frontend.db", function(e){
//  if (e) throw e;
// });
