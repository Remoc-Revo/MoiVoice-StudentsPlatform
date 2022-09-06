const http=require('http');
const port=process.env.port || 3000;
const app=require('./app');
const hostname ='192.168.43.167';

const server=http.createServer(app);

server.listen(port,hostname);