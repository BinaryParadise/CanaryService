(function() {
    if (window.nativeBridge) {
        return;
    }
    window.nativeBridge = function() {
        function postMessage(name, param) {
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.cn_objc) {
                // 1.创建一个 MessageChannel
                var channel = new MessageChannel();
                // 2.
                window.nativeCallBack = function(nativeValue) {
                  // 5.
                  channel.port1.postMessage(nativeValue)
                };
                // 3.
                window.webkit.messageHandlers[name].postMessage(param);
                return new Promise((resolve, reject) => {
                  channel.port2.onmessage = function(e){
                      // 6.
                      var data = e.data;
                      resolve(data);
                      channel = null;
                      window.nativeCallBack = null;
                  }
                })
            }
        }
        return {
            call: function(param, callback) {
                postMessage('cn_objc', param).then(callback);
            }
        }
    }()
})();

