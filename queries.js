require('dotenv').config()

const {Pool} = require('pg')
// Variables de conexión a la base de datos 
const pool = new Pool({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB,
    password: process.env.DB_PASS,
    port: process.env.PORT,
})
// Librería para encriptar peticiones
// En la encriptación de tipos INTEGER O DOUBLE PRECISION se hace conversión a string y se encripta
var aes256 = require('aes256');
var key = "92AE31A79FEEB2A3";
const encrypt=1;






// Función para crear logs de peticiones: createLog(resultado, modulo de petición)
createLog = function ( results, module) { //
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();

    today = mm + '-' + dd + '-' + yyyy;
    var fs = require('fs');
    var util = require('util');

    const dir = './logs';

    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
    }
    // Nombre de los logs Instancia del sp + Fecha actual + Número de archivo (Para evitar sobrescribir)

    fs.readdir(dir, (err, files) => {


        var log_file = fs.createWriteStream(__dirname + '/logs/'+module+'_'+today+'_'+(files.length+1)+'.log', { flags: 'w' });

        log_file.write(util.format(results) + '\n');

    

    });

};

// RF 1.1.1
/* Constante de ejemplo comentado cada elemento  */
// Variable para consultar las tarifas 
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const postConsultaTarifa = (request, response)=>{

    resultado={};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;

    // Query
    var query = "Select * from  ws_consultar_tarifas('"+nivunidad+
    "','"+usuario+
    "','"+contrasena+"')";
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '')
    
    pool.query( 
        query,(error, results)=>{
            
            try{

                
                var contrasenadb = contrasena.replace(/["]+/g, '');
                
                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb){
                    throw "Contraseña incorrecta";
                } 

            
                // Validación en caso de error
                if(error){
                    throw error;
                }
            
                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if(encrypt==1){
                    setTimeout(function(){
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            delete element.pass;
                            element.id_tarifa != null ? element.id_tarifa = aes256.encrypt(key, element.id_tarifa.toString()) : element.id_tarifa = element.id_tarifa;
                            element.concepto_tarifa != null ? element.concepto_tarifa = aes256.encrypt(key, element.concepto_tarifa) : element.concepto_tarifa = element.concepto_tarifa;
                            element.aire_acondicionado != null ? element.aire_acondicionado = aes256.encrypt(key, element.aire_acondicionado) : element.aire_acondicionado = element.aire_acondicionado;
                            element.tarifa_total != null ? element.tarifa_total = aes256.encrypt(key, element.tarifa_total.toString()) : element.tarifa_total = element.tarifa_total;
                            element.primer_descuento != null ? element.primer_descuento = aes256.encrypt(key, element.primer_descuento.toString()) : element.primer_descuento = element.primer_descuento;
                            element.segundo_descuento != null ? element.segundo_descuento = aes256.encrypt(key, element.segundo_descuento.toString()) : element.segundo_descuento = element.segundo_descuento;
                            
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                }else{
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }
                // Creación de log
                createLog(resultado, "ws_consultar_tarifas" );
            }catch(error){
             
            
                createLog(error, "ws_consultar_tarifas");
                if (error == "Contraseña incorrecta"){

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });
                }else{

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”"});
                }
                
            }
        
        }

    )
}



// RF 1.1.2
// Variable para consultar las tarifas 
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const postConsultarOperadoresHabilitados = (request, response) => {

    resultado={};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;


    // Query
    var query = "Select * from  ws_consultar_operadores('" + nivunidad +
        "','" + usuario +
        "','" + contrasena + "')";
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

                // Validación de contraseña cifrada
                var contrasenadb = contrasena.replace(/["]+/g, '');

                
                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb){
                    throw "Contraseña incorrecta";
                }else {
                    delete results.rows[0].pass;
                }   


                // Validación en caso de error
                if (error) {
                    throw error;
                }

                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_operador != null ? element.id_operador = aes256.encrypt(key, element.id_operador.toString()) : element.id_operador = element.id_operador;
                            element.nombre != null ? element.nombre = aes256.encrypt(key, element.nombre) : element.nombre = element.nombre;
                            
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                } else {
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }
                // Creación de log
                createLog(resultado, "ws_consultar_operadores");
            } catch (error) {
                createLog(error, "ws_consultar_operadores");
                if (error == "Contraseña incorrecta") {

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}

// RF 1.1.3
// Variable para asociar un operador a una unidad
// Estatus: Pendiente
// Encriptado: Si
// Creación de archivo .log : Si

const postAsociacionOperadorUnidad = (request, response) => {
    resultado={};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const idoperador = request.body.idoperador;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;


    // Query
    var query = "Select * from  ws_asociar_operador_unidad('" + nivunidad +
        "'," + idoperador +
        ",'" + usuario +
        "','" + contrasena + "')";
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

                // Validación de contraseña cifraada
                var contrasenadb = contrasena.replace(/["]+/g, '');

                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb) {
                    throw "Contraseña incorrecta";
                }else{
                    delete results.rows[0].pass;
                }

                // Validación en caso de error
                if (error) {
                    throw error;
                }

                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_tarifa != null ? element.id_tarifa = aes256.encrypt(key, element.id_tarifa.toString()) : element.id_tarifa = element.id_tarifa;
                            element.concepto_tarifa != null ? element.concepto_tarifa = aes256.encrypt(key, element.concepto_tarifa) : element.concepto_tarifa = element.concepto_tarifa;
                            element.aire_acondicionado != null ? element.aire_acondicionado = aes256.encrypt(key, element.aire_acondicionado) : element.aire_acondicionado = element.aire_acondicionado;
                            element.tarifa_total != null ? element.tarifa_total = aes256.encrypt(key, element.tarifa_total.toString()) : element.tarifa_total = element.tarifa_total;
                            element.primer_descuento != null ? element.primer_descuento = aes256.encrypt(key, element.primer_descuento.toString()) : element.primer_descuento = element.primer_descuento;
                            element.segundo_descuento != null ? element.segundo_descuento = aes256.encrypt(key, element.segundo_descuento.toString()) : element.segundo_descuento = element.segundo_descuento;
                            
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                } else {
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }

                // Creación de log
                createLog(resultado, "ws_asociar_operador_unidad");

            } catch (error) {
                
                createLog(error, "ws_asociar_operador_unidad");
                
                if (error == "Contraseña incorrecta") {

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}


// 1.1.4
// Variable para consultar los administradores asociados a la unidades 
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const postConsultaAdministradoresUnidades = (request, response) => {

    resultado= {};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;


    // Query
    var query = "Select * from  ws_consultar_administradores('" + nivunidad +
        "','" + usuario +
        "','" + contrasena + "')";
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

                // Validación de contraseña cifraada
                var contrasenadb = contrasena.replace(/["]+/g, '');

                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb) {
                    throw "Contraseña incorrecta";
                }else{
                    delete results.rows[0].pass;
                }

                // Validación en caso de error
                if (error) {
                    throw error;
                }

              

                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.numero_tarjeta != null ? element.numero_tarjeta = aes256.encrypt(key, element.numero_tarjeta.toString()) : element.numero_tarjeta = element.numero_tarjeta;
                            element.nip != null ? element.nip = aes256.encrypt(key, element.nip.toString()) : element.nip = element.nip;
                            element.nombre_administrador != null ? element.nombre_administrador = aes256.encrypt(key, element.nombre_administrador) : element.nombre_administrador = element.nombre_administrador;
                         
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);

                    }, 100);

                } else {
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }
                // Creación de log
                createLog(resultado, "ws_consultar_administradores");
            } catch (error) {
                createLog(error, "ws_consultar_administradores");
            
                if (error == "Contraseña incorrecta") {

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}

// 1.2
// Variable para consultar el operador en turno de una unidad
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const postConsultaOperadorUnidadTurno = (request, response) => {
    resultado={};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;


    // Query
    var query = "Select * from  ws_consultar_operador_turno('" + nivunidad +
        "','" + usuario +
        "','" + contrasena + "')";
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

                // Validación de contraseña cifraada
                var contrasenadb = contrasena.replace(/["]+/g, '');

                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb) {
                    throw "Contraseña incorrecta";
                }else{
                    delete results.rows[0].pass;
                }

                // Validación en caso de error
                if (error) {
                    throw error;
                }

                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_operador != null ? element.id_operador = aes256.encrypt(key, element.id_operador.toString()) : element.id_operador = element.id_operador;
                            element.nombre_operador != null ? element.nombre_operador = aes256.encrypt(key, element.nombre_operador.toString()) : element.nombre_operador = element.nombre_operador;
                            
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100)
                    
                } else {
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }
                // Creación de log
                createLog(results.rows, "ws_consultar_operador_turno");

            } catch (error) {
                createLog(error, "ws_consultar_operador_turno");
                if (error == "Contraseña incorrecta") {

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}

// 1.2.1
// Variable para consultar información del operador
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const consultaOperador = (request, response) => {

    resultado= {};

    // Variables de entrada
    const idoperador = request.body.idoperador;


    // Query
    var query = "Select * from  ws_consultar_datos_operador(" + idoperador +")";

    
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

          
                // Validación en caso de error
                if (error) {
                    throw error;
                }

                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_operador != null ? element.id_operador = aes256.encrypt(key, element.id_operador.toString()) : element.id_operador = element.id_operador;
                            element.nombre_operador != null ? element.nombre_operador = aes256.encrypt(key, element.nombre_operador.toString()) : element.nombre_operador = element.nombre_operador;
                            element.licencia != null ? element.licencia = aes256.encrypt(key, element.licencia.toString()) : element.licencia = element.licencia;
                            element.fotografia != null ? element.fotografia = aes256.encrypt(key, element.fotografia.toString()) : element.fotografia = element.fotografia;

                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                } else {
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                }
                // Creación de log
                createLog(results.rows, "ws_consultar_datos_operador");
            } catch (error) {
                createLog(error, "ws_consultar_datos_operador");
                response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                
            }

        }

    )
}

// 1.3
// Variable para registrar los pagos
// Estatus: Pendiente
// Encriptado: Si
// Creación de archivo .log : Si

const registroPago = (request, response) => {

    resultado ={};

    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;
    const referenciausuario = request.body.referenciausuario;
    const idservicio = request.body.idservicio;
    const formapago = request.body.formapago;
    const cantidad = request.body.cantidad;
    const importe = request.body.importe;
    const total = request.body.total;
    const denominacionesrecibidas = request.body.denominacionesrecibidas;
    const denominacionesentregadas = request.body.denominacionesentregadas;
    const fechahora = request.body.fechahora;

    // Query
    var query = "Select * from  ws_registrar_pago('" + nivunidad + "', '"+usuario+"','"+contrasena+"','"+referenciausuario+
    "',"+idservicio+
    ","+formapago+
    ","+cantidad+
    ","+importe+
    ","+total+
    ",'"+denominacionesrecibidas+
    "','"+denominacionesentregadas+
    "','"+fechahora+"' )";

    
    
    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');
 

    pool.query(
        query, (error, results) => {

            try {
               
                // Validación de contraseña cifraada
                var contrasenadb = contrasena.replace(/["]+/g, '');
                

                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb) {
                    throw "Contraseña incorrecta";
                }else{
                    delete results.rows[0].pass;
                }

                // Validación en caso de error
                if (error) {
                    throw error;
                }

                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_operacion != null ? element.id_operacion = aes256.encrypt(key, element.id_operacion.toString()) : element.id_operacion = element.id_operacion;
                            
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                } else {
                    
                    results.rows.forEach(function (element) {
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass;
                    });
                    resultado.datos = results.rows;
                    response.status(200).json(resultado);
                    
                }
                // Creación de log
                createLog(results.rows, "ws_registrar_pago");
            } catch (error) {
                createLog(error, "ws_registrar_pago");
                if (error == "Contraseña incorrecta") {
                    
                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}

// 1.4
// Variable para consultar el catalogo de servicios
// Estatus: Terminado
// Encriptado: Si
// Creación de archivo .log : Si

const consultaCatalogoServicio = (request, response) => {

    var resultado={};
    // Variables de entrada
    const nivunidad = request.body.nivunidad;
    const usuario = request.body.usuario;
    const contrasena = request.body.contrasena;

    // Query
    var query = "Select * from  ws_consultar_catalogo_servicios('" + nivunidad +
        "','" + usuario +
        "','" + contrasena + "')";


    // Se reemplaza las comillas doble por simples para la consulta
    query = query.replace(/["]+/g, '');

    pool.query(
        query, (error, results) => {

            try {

                // Validación de contraseña cifraada
                var contrasenadb = contrasena.replace(/["]+/g, '');

                if (aes256.decrypt(key, results.rows[0].pass) != contrasenadb) {
                    throw "Contraseña incorrecta";
                }

                // Validación en caso de error
                if (error) {
                    throw error;
                }
                
                // Call back pata encriptar cada elemento de la respuesta para envío1
                // El call back se utilizó para dar un tiempo en lo que se crea el log y se envía la información
                if (encrypt == 1) {
                    setTimeout(function () {
                        results.rows.forEach(function (element) {
                            element.msg = aes256.encrypt(key, element.msg);
                            resultado.msg = element.msg;
                            delete element.msg;
                            element.id_servicio != null ? element.id_servicio = aes256.encrypt(key, element.id_servicio.toString()) : element.id_servicio = element.id_servicio;
                            element.nombre_servicio != null ? element.nombre_servicio = aes256.encrypt(key, element.nombre_servicio) : element.nombre_servicio = element.nombre_servicio;
                            
                            delete element.pass; 
                        })
                        resultado.data = results.rows;
                        response.status(200).json(resultado);
                        
                    }, 100);
                    
                } else {
                    
                    results.rows.forEach(function(element){
                        resultado.msg = element.msg;
                        delete element.msg;
                        delete element.pass; 
                    });
                    resultado.datos= results.rows;
                    response.status(200).json(resultado);
                    
                    
                }

                // Creación de log
                createLog(results.rows, "ws_consultar_catalogo_servicios");
            } catch (error) {
                createLog(error, "ws_consultar_catalogo_servicios");
                if (error == "Contraseña incorrecta") {

                    response.status(404).json({ msg: '005, “Usuario y/o contraseña inválidos”' });

                } else {

                    response.status(404).json({ msg: "015, “No se estableció conexión con la base de datos de monedero”" });
                }
            }

        }

    )
}

const consultaWebService=(request, response)=>{
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    var yyyy = today.getFullYear();
    today = mm + '/' + dd + '/' + yyyy;

    if (encrypt==1){

        var info = {
            version:aes256.encrypt(key,"1.0"),
            fecha:aes256.encrypt(key,today),
            licencia:aes256.encrypt(key,"Perpetua"),
            vigencia:aes256.encrypt(key,"-")
        };

    }else{
        var info = {
            version: "1.0",
            fecha: today,
            licencia: "Perpetua",
            vigencia: "-"
        };
    }


    createLog(response.send(info))
}
module.exports = {
    
    postConsultaTarifa,
    postConsultarOperadoresHabilitados,
    postAsociacionOperadorUnidad,
    postConsultaAdministradoresUnidades,
    postConsultaOperadorUnidadTurno,
    consultaOperador,
    registroPago,
    consultaCatalogoServicio,
    consultaWebService
    
    

}
