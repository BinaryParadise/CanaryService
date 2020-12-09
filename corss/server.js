//take data from a read stream and then pipe it into a write stream
var http = require('http');
//fs allow you to work with file system
var fs = require('fs');

var server = http.createServer(function (req,res) {
    console.log('request was made' + req.url);
    //set the States and content type
    //if you want to link to html, you need to change the Content-Tyke from text/plain to text/html
    res.writeHead(200, {'Content-Type': 'text/html'});
    //the path also need to be changed
    var readStream = fs.createReadStream(__dirname + '/index.html', 'utf-8');
    
    readStream.pipe(res);
//    end the respond and send it to the browser
    //res.end('Hey set to the browser')
});

//set a port for request
server.listen(8082);
console.log('cool, listening to port 8082');