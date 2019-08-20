const http = require('http'); //HACE REFERENCIA A UN PAQUETE QUE INCLUYE NODEjs
const url = require('url');

const hostname = '127.0.0.1'; //DIRECCION DEL SERVIDOR
const port = process.env.port; //PUERTO

//CALLBACK
const server = http.createServer(function (req, res){
  var myURL = url.parse(req.url);
  if (req.method =="GET"){
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end(myURL.pathname);
  }else{
    res.statusCode = 400;
  }
});
//var miFuncion = function(req, res){
//};
//const server = http.createServer(miFuncion);
server.listen(port, hostname, function(){
  console.log(`Servidor ejecutandose en http://${hostname}:${port}`);
})
