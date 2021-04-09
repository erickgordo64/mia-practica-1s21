CREATE DEFINER=`root`@`localhost` PROCEDURE `cargar_datosbd`()
BEGIN
	-- -------------------------------------------------------
	-- INSERTAR EN VICTIMA %Y-%m-%d %H:%i:%s
	-- -------------------------------------------------------
	-- ------ insert------------
	insert into victima(NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, FECHA_PRIMERA_SOSPECHA, FECHA_CONFIRMACION, FECHA_MUERTE, ESTADO_VICTIMA) 
	select NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, 
	FECHA_PRIMERA_SOSPECHA, 
	FECHA_CONFIRMACION, 
	str_to_date(FECHA_MUERTE, '%Y-%m-%d %H:%i:%s') as fecha_muerte,
	ESTADO_VICTIMA from temporal where NOMBRE_VICTIMA!=''
	group by NOMBRE_VICTIMA, APELLIDO_VICTIMA, DIRECCION_VICTIMA, FECHA_PRIMERA_SOSPECHA, FECHA_CONFIRMACION, FECHA_MUERTE, ESTADO_VICTIMA;
	-- ----------------------------------------------------------
	-- insertar hospital
	-- ----------------------------------------------------------
	-- insert
	insert into hospital(NOMBRE_HOSPITAL, DIRECCION_HOSPITAL) select NOMBRE_HOSPITAL, DIRECCION_HOSPITAL from temporal where NOMBRE_HOSPITAL!='' group by NOMBRE_HOSPITAL, DIRECCION_HOSPITAL;
	-- ---------------------------------------------------------------
	-- INSERTAR TRATAMIENTO
	-- ----------------------------------------------------------------
	-- insert
	insert into tratamiento(TRATAMIENTO, EFECTIVIDAD) select TRATAMIENTO, EFECTIVIDAD from temporal where TRATAMIENTO!='' group by tratamiento, efectividad;
	-- -----------------------------------------------------------------
	-- INSERTAR PERSONA ASOCIADA
	-- -----------------------------------------------------------------
	-- INSERT
	INSERT INTO persona_asosiada(NOMBRE_ASOCIADO, APELLIDO_ASOCIADO) SELECT NOMBRE_ASOCIADO, APELLIDO_ASOCIADO FROM TEMPORAL WHERE NOMBRE_ASOCIADO!='' group by NOMBRE_ASOCIADO, APELLIDO_ASOCIADO;
	-- -----------------------------------------------------------------
	-- INSERTAR TIPO CONTACTO
	-- ------------------------------------------------------------------
	-- insert
	insert into tipo_contacto(CONTACTO_FISICO) select CONTACTO_FISICO FROM temporal where CONTACTO_FISICO!='' group by CONTACTO_FISICO;
	-- -----------------------------------------------------------
	-- insertar ubicacion victima ENCONTRE ERROR CORREGIR
	-- -----------------------------------------------------------
	-- INSERT
	insert into ubicacion_victima(UBICACION_VCTIMA, FECHA_LLEGADA, FECHA_RETIRO, victima_idvictima) 
	select UBICACION_VICTIMA, str_to_date(FECHA_LLEGADA, '%Y-%m-%d %H:%i:%s') AS fecha_llega,
	str_to_date(FECHA_RETIRO, '%Y-%m-%d %H:%i:%s') as fecha_retira,  victima.idvictima  FROM temporal 
	inner join victima on victima.NOMBRE_VICTIMA=temporal.NOMBRE_VICTIMA AND victima.APELLIDO_VICTIMA=temporal.APELLIDO_VICTIMA
	where UBICACION_VICTIMA!='' group by UBICACION_VICTIMA, idvictima
	order by idvictima ASC;
	-- --------------------------------------------------------------
	-- insertar registro paciente ENCONTRE ERROR CORREGIR
	-- -------------------------------------------------------------
	-- insert
	insert into registro_paciente(hospital_idhospital, victima_idvictima)
	select hospital.idhospital, victima.idvictima from temporal 
	inner join hospital on hospital.NOMBRE_HOSPITAL=temporal.NOMBRE_HOSPITAL
	inner join victima on victima.NOMBRE_VICTIMA=temporal.NOMBRE_VICTIMA AND victima.APELLIDO_VICTIMA=temporal.APELLIDO_VICTIMA
	group by idvictima order BY idvictima ASC;
	-- ------------------------------------------------------------------------
	-- detalle_tratamiento ENCONTRE ERROR CORREGIR
	-- ------------------------------------------------------------------------
	-- insert
	insert into detalle_tratamiento(FECHA_INICIO_TRATAMIENTO, FECHA_FIN_TRATAMIENTO, EFECTIVIDAD_EN_VICTIMA, victima_idvictima, tratamiento_idtratamiento)
	select FECHA_INICIO_TRATAMIENTO, FECHA_FIN_TRATAMIENTO, EFECTIVIDAD_EN_VICTIMA, victima.idvictima, tratamiento.idtratamiento from temporal
	inner join victima on victima.NOMBRE_VICTIMA=temporal.NOMBRE_VICTIMA AND victima.APELLIDO_VICTIMA=temporal.APELLIDO_VICTIMA
	inner join tratamiento on tratamiento.TRATAMIENTO=temporal.TRATAMIENTO
	GROUP BY idvictima, FECHA_INICIO_TRATAMIENTO, FECHA_FIN_TRATAMIENTO
	order by idvictima, FECHA_INICIO_TRATAMIENTO asc;
	-- -----------------------------------------------------------------------
	-- insertar detalle perosona asociada
	-- ------------------------------------------------------------------------ 
	-- insert
	insert into detalle_persona_asociada(FECHA_CONOCIO, FECHA_INICIO_CONTACTO, FECHA_FIN_CONTACTO, victima_idvictima, persona_asosiada_idpersona_asosiada, tipo_contacto_idtipo_contacto)
	select FECHA_CONOCIO, FECHA_INICIO_CONTACTO, FECHA_FIN_CONTACTO, victima.idvictima, persona_asosiada.idpersona_asosiada, tipo_contacto.idtipo_contacto  from temporal
	inNer join persona_asosiada on persona_asosiada.NOMBRE_ASOCIADO=temporal.NOMBRE_ASOCIADO AND persona_asosiada.APELLIDO_ASOCIADO=temporal.APELLIDO_ASOCIADO
	inner join victima on victima.NOMBRE_VICTIMA=temporal.NOMBRE_VICTIMA AND victima.APELLIDO_VICTIMA=temporal.APELLIDO_VICTIMA
	inner join tipo_contacto on tipo_contacto.CONTACTO_FISICO=temporal.CONTACTO_FISICO
	group by idpersona_asosiada, idvictima, idtipo_contacto, FECHA_CONOCIO, FECHA_INICIO_CONTACTO, FECHA_FIN_CONTACTO
	ORDER BY idvictima asc;
END