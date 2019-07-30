const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const db = require('./queries')
const port = 3000

app.use(bodyParser.json())
app.use(
    bodyParser.urlencoded({
        extended: true,
    })
)

//CONSULTAR RAIZ CON METODO GET
app.get('/', function(req, res){
    res.send("Web service ejecutandose\n");
});

app.post('/tarifa/consultar', db.postConsultaTarifa)

app.post('/operador/consultar/habilitado', db.postConsultarOperadoresHabilitados)

app.post('/operador/asociar', db.postAsociacionOperadorUnidad)

app.post ('/administradores/unidades/consulta', db.postConsultaAdministradoresUnidades)

app.post('/operador/consulta/unidad/turno', db.postConsultaOperadorUnidadTurno)

app.post('/operador/consulta', db.consultaOperador)

app.post('/pago/registrar', db.registroPago)

app.post('/servicio/consulta', db.consultaCatalogoServicio)

app.post('/webservice/consulta', db.consultaWebService)






app.listen(port, () => console.log(`Web service escuchando por puerto ${port}`)) 


