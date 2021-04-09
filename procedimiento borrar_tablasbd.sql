CREATE DEFINER=`root`@`localhost` PROCEDURE `borrar_tablasbd`()
BEGIN
	drop table registro_paciente;
	drop table ubicacion_victima;
	drop table detalle_persona_asociada;
	drop table detalle_tratamiento;
	drop table victima;
	drop table hospital;
	drop table tratamiento;
	drop table persona_asosiada;
	drop table tipo_contacto;
END