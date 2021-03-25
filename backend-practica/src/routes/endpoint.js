const { Router } = require('express');
const router = Router();
//const BD = require('../config/dbconfig');
const pool = require('../config/dbconfig');
const multipart = require('connect-multiparty');                                                                    
let csvToJson = require('convert-csv-to-json');
var mysql = require('mysql');
//var connection = mysql.createConnection(BD.databaseOptions);

const multiPartMiddleware = multipart();
let json=null
const Json=null;

router.get('/', async (req, res) => {
    res.status(200);
})

router.get('/getUsuarios', async (req, res) => {

    var sql='select * from temporal'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.post('/addArchivo', multiPartMiddleware, async(req, res) => {

    console.log("body ", req.body, "file ", req.files);
    
    var file = req.files.file;
    var dato=[];

    console.log(file.path);

    let fileInputName = file.path;
    let fileOutputName = './subidas/myOutputFile.json';

    // csvToJson.generateJsonFileFromCsv(fileInputName, fileOutputName);
    //csvToJson.fieldDelimiter(',').getJsonFromCsv(fileInputName);

    json = csvToJson.fieldDelimiter(';').getJsonFromCsv(fileInputName);

    let Json=json;

    for (let i = 0; i < json.length; i++) {
       // console.log(json[i].NOMBRE_VICTIMA);
       var NOMBRE_VICTIMA=json[i].NOMBRE_VICTIMA;
       var APELLIDO_VICTIMA=json[i].APELLIDO_VICTIMA;
       var DIRECCION_VICTIMA=json[i].DIRECCION_VICTIMA;
       var FECHA_PRIMERA_SOSPECHA=json[i].FECHA_PRIMERA_SOSPECHA;
       var FECHA_CONFIRMACION=json[i].FECHA_CONFIRMACION;
       var FECHA_MUERTE=json[i].FECHA_MUERTE;
       var ESTADO_VICTIMA=json[i].ESTADO_VICTIMA;
       var NOMBRE_ASOCIADO=json[i].NOMBRE_ASOCIADO;
       var APELLIDO_ASOCIADO=json[i].APELLIDO_ASOCIADO;
       var FECHA_CONOCIO=json[i].FECHA_CONOCIO;
       var CONTACTO_FISICO=json[i].CONTACTO_FISICO;
       var FECHA_INICIO_CONTACTO=json[i].FECHA_INICIO_CONTACTO;
       var FECHA_FIN_CONTACTO=json[i].FECHA_FIN_CONTACTO;
       var NOMBRE_HOSPITAL=json[i].NOMBRE_HOSPITAL;
       var DIRECCION_HOSPITAL=json[i].DIRECCION_HOSPITAL;
       var UBICACION_VICTIMA=json[i].UBICACION_VICTIMA;
       var FECHA_LLEGADA=json[i].FECHA_LLEGADA;
       var FECHA_RETIRO=json[i].FECHA_RETIRO;
       var TRATAMIENTO=json[i].TRATAMIENTO;
       var EFECTIVIDAD=json[i].EFECTIVIDAD;
       var FECHA_INICIO_TRATAMIENTO=json[i].FECHA_INICIO_TRATAMIENTO;
       var FECHA_FIN_TRATAMIENTO=json[i].FECHA_FIN_TRATAMIENTO;
       var EFECTIVIDAD_EN_VICTIMA=json[i].EFECTIVIDAD_EN_VICTIMA;

        var values=[[NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, FECHA_PRIMERA_SOSPECHA, FECHA_CONFIRMACION, FECHA_MUERTE, ESTADO_VICTIMA, NOMBRE_ASOCIADO, APELLIDO_ASOCIADO, FECHA_CONOCIO, CONTACTO_FISICO, FECHA_INICIO_CONTACTO, FECHA_FIN_CONTACTO, NOMBRE_HOSPITAL, DIRECCION_HOSPITAL, UBICACION_VICTIMA, FECHA_LLEGADA, FECHA_RETIRO, TRATAMIENTO, EFECTIVIDAD, FECHA_INICIO_TRATAMIENTO ,FECHA_FIN_TRATAMIENTO, EFECTIVIDAD_EN_VICTIMA]];
        
        sql="INSERT INTO temporal (NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, FECHA_PRIMERA_SOSPECHA, FECHA_CONFIRMACION, FECHA_MUERTE, ESTADO_VICTIMA, NOMBRE_ASOCIADO, APELLIDO_ASOCIADO, FECHA_CONOCIO, CONTACTO_FISICO, FECHA_INICIO_CONTACTO, FECHA_FIN_CONTACTO, NOMBRE_HOSPITAL, DIRECCION_HOSPITAL, UBICACION_VICTIMA, FECHA_LLEGADA, FECHA_RETIRO, TRATAMIENTO, EFECTIVIDAD, FECHA_INICIO_TRATAMIENTO ,FECHA_FIN_TRATAMIENTO, EFECTIVIDAD_EN_VICTIMA) VALUES (?)"

        pool.query(sql, values, function (err, result) {
            if (err) throw err;
            //console.log("Number of records inserted: " + result.affectedRows);
          });
        //dato.push(values);
    }
    //console.log(dato);
    res.status(200).json({
        dato
    })

});
                       

module.exports=router;