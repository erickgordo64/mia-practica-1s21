-- CONSULTA 1
select hospital.NOMBRE_HOSPITAL, hospital.DIRECCION_HOSPITAL, count(victima.FECHA_MUERTE) as muertos from registro_paciente
inner join hospital on registro_paciente.hospital_idhospital=hospital.idhospital
inner join victima on registro_paciente.victima_idvictima=victima.idvictima
group by idhospital ORDER BY NOMBRE_HOSPITAL ASC;
-- CONSULTA 2
select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA from detalle_tratamiento
inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima
inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento
where ESTADO_VICTIMA='En Cuarentena' and EFECTIVIDAD_EN_VICTIMA>5 and TRATAMIENTO='Transfusiones de sangre' GROUP BY idvictima;
-- CONSULTA 3
select count(victima_idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA, victima.FECHA_MUERTE from detalle_persona_asociada
inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima
where  victima.FECHA_MUERTE!='0000-00-00 00:00:00'
group by victima.idvictima, victima.FECHA_MUERTE
having dato>3;
-- CONSULTA 4
select count(victima_idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.ESTADO_VICTIMA, tipo_contacto.CONTACTO_FISICO FROM detalle_persona_asociada
inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima
inner join tipo_contacto on tipo_contacto.idtipo_contacto=detalle_persona_asociada.tipo_contacto_idtipo_contacto
where CONTACTO_FISICO='Beso' AND ESTADO_VICTIMA='Sospecha'
group by victima_idvictima
having dato>2;
-- CONSULTA 5
select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(tratamiento_idtratamiento) as dato from detalle_tratamiento
inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima
inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento
where TRATAMIENTO='Oxigeno'
group by idvictima order by dato  desc limit 5;
-- CONSULTA 6
select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.FECHA_MUERTE, ubicacion_victima.UBICACION_VCTIMA, tratamiento.TRATAMIENTO FROM detalle_tratamiento 
inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima
inner join tratamiento on tratamiento.idtratamiento=detalle_tratamiento.tratamiento_idtratamiento
inner join ubicacion_victima on victima.idvictima=ubicacion_victima.victima_idvictima
where UBICACION_VCTIMA='1987 Delphine Well' and TRATAMIENTO='Manejo de la presión arterial' AND FECHA_MUERTE!='0000-00-00 00:00:00'
group by idvictima;
-- consulta 7
select count(detalle_tratamiento.victima_idvictima) as dato, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, 
victima.DIRECCION_VICTIMA, count(detalle_tratamiento.tratamiento_idtratamiento) as trata from victima
inner join registro_paciente on registro_paciente.victima_idvictima=victima.idvictima
inner join detalle_tratamiento on detalle_tratamiento.victima_idvictima=victima.idvictima
inner join detalle_persona_asociada on detalle_persona_asociada.victima_idvictima=victima.idvictima
where  victima.FECHA_MUERTE!='0000-00-00 00:00:00'
group by victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA
having dato<2 and trata=2;
-- alternativa consulta 7
select victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA FROM registro_paciente
inner join victima on victima.idvictima=registro_paciente.victima_idvictima
where (select count(*) from detalle_persona_asociada as DPA where DPA.victima_idvictima=victima.idvictima) <2
and (select count(*) from detalle_tratamiento as DPT where DPT.victima_idvictima=victima.idvictima) =2
and victima.FECHA_MUERTE!='0000-00-00 00:00:00'
group by victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, victima.DIRECCION_VICTIMA;
-- consulta 8
(select month(victima.FECHA_PRIMERA_SOSPECHA) AS MES, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(tratamiento_idtratamiento) as cantidad_tratamiento FROM detalle_tratamiento
inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima
group by idvictima order by cantidad_tratamiento desc limit 5)
union 
(select month(victima.FECHA_PRIMERA_SOSPECHA) AS MES, victima.NOMBRE_VICTIMA, victima.APELLIDO_VICTIMA, count(tratamiento_idtratamiento) as cantidad_tratamiento FROM detalle_tratamiento
inner join victima on victima.idvictima=detalle_tratamiento.victima_idvictima
group by idvictima order by cantidad_tratamiento asc limit 5);
-- consulta 9
select count(hospital_idhospital) as pacientes_hospital, ((count(hospital_idhospital)/(select count(idvictima) from victima))*100) as porcentaje, hospital.NOMBRE_HOSPITAL 
from registro_paciente
inner join hospital on hospital.idhospital=registro_paciente.hospital_idhospital
group by hospital_idhospital;
-- consulta 10
select count(tipo_contacto_idtipo_contacto) as contacto_repetido, hospital.idhospital, tipo_contacto.CONTACTO_FISICO, hospital.NOMBRE_HOSPITAL,
((count(tipo_contacto_idtipo_contacto)/(select count(tipo_contacto_idtipo_contacto) from detalle_persona_asociada))*100) as porcentaje
from detalle_persona_asociada 
inner join tipo_contacto on tipo_contacto.idtipo_contacto=detalle_persona_asociada.tipo_contacto_idtipo_contacto
inner join victima on victima.idvictima=detalle_persona_asociada.victima_idvictima
inner join registro_paciente on registro_paciente.victima_idvictima=victima.idvictima
inner join hospital on hospital.idhospital=registro_paciente.hospital_idhospital
group by idhospital, idtipo_contacto order by idhospital

