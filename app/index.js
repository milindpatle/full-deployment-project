const http = require('http');
const port = 5000;

http.createServer((req, res) => {
  res.end("Hello from NodeJS App!");
}).listen(port);
