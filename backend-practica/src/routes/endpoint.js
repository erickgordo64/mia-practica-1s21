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

router.get('/Consulta1', async (req, res) => {

    var sql='select hospital.NOMBRE_HOSPITAL, hospital.DIRECCION_HOSPITAL, count(victima.FECHA_MUERTE) as MUERTOS' 
    +' from registro_paciente inner join hospital on registro_paciente.hospital_idhospital=hospital.idhospital' 
    +' inner join victima on registro_paciente.victima_idvictima=victima.idvictima'
    +' group by hospital_idhospital ORDER BY NOMBRE_HOSPITAL ASC'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta2', async (req, res) => {

    var sql='select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA from detalle_tratamiento'
    +' inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima'
    +' inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento'
    +' where ESTADO_VICTIMA=\'En Cuarentena\' and EFECTIVIDAD_EN_VICTIMA>5 and TRATAMIENTO=\'Transfusiones de sangre\' GROUP BY idvictima'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta3', async (req, res) => {

    var sql='select count(victima_idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA, victima.FECHA_MUERTE from detalle_persona_asociada'
    +' inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima'
    +' where  victima.FECHA_MUERTE!=\'0000-00-00 00:00:00\''
    +' group by victima.idvictima'
    +' having dato>3'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta4', async (req, res) => {

    var sql='select count(victima_idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.ESTADO_VICTIMA, tipo_contacto.CONTACTO_FISICO FROM detalle_persona_asociada'
    +' inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima'
    +' inner join tipo_contacto on tipo_contacto.idtipo_contacto=detalle_persona_asociada.tipo_contacto_idtipo_contacto'
    +' where CONTACTO_FISICO=\'Beso\' AND ESTADO_VICTIMA=\'Sospecha\''
    +' group by victima_idvictima'
    +' having dato>2;'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta5', async (req, res) => {

    var sql='select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(victima_idvictima) as dato from detalle_tratamiento'
    +' inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima'
    +' inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento'
    +' where TRATAMIENTO=\'Oxigeno\''
    +' group by idvictima order by dato  desc limit 5'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta6', async (req, res) => {

    var sql='select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.FECHA_MUERTE, ubicacion_victima.UBICACION_VCTIMA, tratamiento.TRATAMIENTO FROM detalle_tratamiento' 
    +' inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima'
    +' inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento'
    +' inner join ubicacion_victima on victima.idvictima=ubicacion_victima.victima_idvictima'
    +' where UBICACION_VCTIMA=\'1987 Delphine Well\' and TRATAMIENTO=\'Manejo de la presión arterial\' AND FECHA_MUERTE!=\'0000-00-00 00:00:00\''
    +' group by idvictima;'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta7', async (req, res) => {

    var sql='select count(idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA, count(detalle_tratamiento.tratamiento_idtratamiento) as trata, registro_paciente.FECHA_LLEGADA from victima'
    +' inner join registro_paciente on registro_paciente.victima_idvictima=victima.idvictima'
    +' inner join detalle_tratamiento on detalle_tratamiento.victima_idvictima=victima.idvictima'
    +' inner join detalle_persona_asociada on detalle_persona_asociada.victima_idvictima=victima.idvictima'
    +' where  victima.FECHA_MUERTE!=\'0000-00-00 00:00:00\' and registro_paciente.FECHA_LLEGADA!=\'0000-00-00 00:00:00\''
    +' group by victima.idvictima'
    +' having dato<2 and trata=2'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta8', async (req, res) => {

    var sql='(select month(victima.FECHA_PRIMERA_SOSPECHA) AS MES, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(tratamiento_idtratamiento) as cantidad_tratamiento FROM detalle_tratamiento'
    +' inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima'
    +' group by idvictima order by cantidad_tratamiento desc limit 5)'
    +' union' 
    +' (select month(victima.FECHA_PRIMERA_SOSPECHA) AS MES, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(tratamiento_idtratamiento) as cantidad_tratamiento FROM detalle_tratamiento'
    +' inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima'
    +' group by idvictima order by cantidad_tratamiento asc limit 5)'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta9', async (req, res) => {

    var sql='select count(hospital_idhospital) as pacientes_hospital, ((count(hospital_idhospital)/(select count(idregistro_paciente) from registro_paciente))*100) as porcentaje, hospital_idhospital, hospital.NOMBRE_HOSPITAL from registro_paciente'
    +' inner join hospital on hospital.idhospital=registro_paciente.hospital_idhospital'
    +' group by hospital_idhospital'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

router.get('/Consulta10', async (req, res) => {

    var sql='select count(tipo_contacto_idtipo_contacto) as contacto_repetido, hospital.idhospital, tipo_contacto.CONTACTO_FISICO, hospital.NOMBRE_HOSPITAL,'
    +' ((count(tipo_contacto_idtipo_contacto)/(select count(tipo_contacto_idtipo_contacto) from detalle_persona_asociada))*100) as porcentaje'
    +' from detalle_persona_asociada '
    +' inner join tipo_contacto on tipo_contacto.idtipo_contacto=detalle_persona_asociada.tipo_contacto_idtipo_contacto'
    +' inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima'
    +' inner join registro_paciente on registro_paciente.victima_idvictima=victima.idvictima'
    +' inner join hospital on hospital.idhospital=registro_paciente.hospital_idhospital'
    +' group by idhospital, idtipo_contacto order by idhospital'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});


router.get('/prueba', async(req, res)=> {
    var sql='call prueba'

    pool.query(sql, (error, result) => {
        if (error) throw error;
 
        res.send(result);
    });
});

module.exports=router;