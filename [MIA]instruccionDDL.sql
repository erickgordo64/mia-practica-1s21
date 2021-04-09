SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema practica1s2021
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema practica1s2021
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `practica1s2021` DEFAULT CHARACTER SET utf8 ;
USE `practica1s2021` ;

-- -----------------------------------------------------
-- Table `practica1s2021`.`hospital`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`hospital` (
  `idhospital` INT NOT NULL AUTO_INCREMENT,
  `NOMBRE_HOSPITAL` VARCHAR(150) NULL,
  `DIRECCION_HOSPITAL` VARCHAR(150) NULL,
  PRIMARY KEY (`idhospital`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`victima`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`victima` (
  `idvictima` INT NOT NULL AUTO_INCREMENT,
  `NOMBRE_VICTIMA` VARCHAR(150) NULL,
  `APELLIDO_VICTIMA` VARCHAR(150) NULL,
  `DIRECCION_VICTIMA` VARCHAR(150) NULL,
  `FECHA_PRIMERA_SOSPECHA` DATETIME NULL,
  `FECHA_CONFIRMACION` DATETIME NULL,
  `FECHA_MUERTE` DATETIME NULL DEFAULT NULL,
  `ESTADO_VICTIMA` VARCHAR(100) NULL,
  PRIMARY KEY (`idvictima`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`persona_asosiada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`persona_asosiada` (
  `idpersona_asosiada` INT NOT NULL AUTO_INCREMENT,
  `NOMBRE_ASOCIADO` VARCHAR(150) NULL,
  `APELLIDO_ASOCIADO` VARCHAR(150) NULL,
  PRIMARY KEY (`idpersona_asosiada`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`tratamiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`tratamiento` (
  `idtratamiento` INT NOT NULL AUTO_INCREMENT,
  `TRATAMIENTO` VARCHAR(150) NULL,
  `EFECTIVIDAD` INT NULL,
  PRIMARY KEY (`idtratamiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`detalle_tratamiento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`detalle_tratamiento` (
  `iddetalle_tratamiento` INT NOT NULL AUTO_INCREMENT,
  `FECHA_INICIO_TRATAMIENTO` DATETIME NULL,
  `FECHA_FIN_TRATAMIENTO` DATETIME NULL,
  `EFECTIVIDAD_EN_VICTIMA` INT NULL,
  `victima_idvictima` INT NOT NULL,
  `tratamiento_idtratamiento` INT NOT NULL,
  PRIMARY KEY (`iddetalle_tratamiento`),
  INDEX `fk_detalle_tratamiento_victima1_idx` (`victima_idvictima` ASC) VISIBLE,
  INDEX `fk_detalle_tratamiento_tratamiento1_idx` (`tratamiento_idtratamiento` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_tratamiento_victima1`
    FOREIGN KEY (`victima_idvictima`)
    REFERENCES `practica1s2021`.`victima` (`idvictima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_tratamiento_tratamiento1`
    FOREIGN KEY (`tratamiento_idtratamiento`)
    REFERENCES `practica1s2021`.`tratamiento` (`idtratamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`tipo_contacto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`tipo_contacto` (
  `idtipo_contacto` INT NOT NULL AUTO_INCREMENT,
  `CONTACTO_FISICO` VARCHAR(45) NULL,
  PRIMARY KEY (`idtipo_contacto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`detalle_persona_asociada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`detalle_persona_asociada` (
  `iddetalle_persona_asociada` INT NOT NULL AUTO_INCREMENT,
  `FECHA_CONOCIO` DATETIME NULL,
  `FECHA_INICIO_CONTACTO` DATETIME NULL,
  `FECHA_FIN_CONTACTO` DATETIME NULL,
  `victima_idvictima` INT NOT NULL,
  `persona_asosiada_idpersona_asosiada` INT NOT NULL,
  `tipo_contacto_idtipo_contacto` INT NOT NULL,
  PRIMARY KEY (`iddetalle_persona_asociada`),
  INDEX `fk_detalle_persona_asociada_victima_idx` (`victima_idvictima` ASC) VISIBLE,
  INDEX `fk_detalle_persona_asociada_persona_asosiada1_idx` (`persona_asosiada_idpersona_asosiada` ASC) VISIBLE,
  INDEX `fk_detalle_persona_asociada_tipo_contacto1_idx` (`tipo_contacto_idtipo_contacto` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_persona_asociada_victima`
    FOREIGN KEY (`victima_idvictima`)
    REFERENCES `practica1s2021`.`victima` (`idvictima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_persona_asociada_persona_asosiada1`
    FOREIGN KEY (`persona_asosiada_idpersona_asosiada`)
    REFERENCES `practica1s2021`.`persona_asosiada` (`idpersona_asosiada`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_persona_asociada_tipo_contacto1`
    FOREIGN KEY (`tipo_contacto_idtipo_contacto`)
    REFERENCES `practica1s2021`.`tipo_contacto` (`idtipo_contacto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`registro_paciente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`registro_paciente` (
  `idregistro_paciente` INT NOT NULL AUTO_INCREMENT,
  `hospital_idhospital` INT NOT NULL,
  `victima_idvictima` INT NOT NULL,
  PRIMARY KEY (`idregistro_paciente`),
  INDEX `fk_registro_paciente_hospital1_idx` (`hospital_idhospital` ASC) VISIBLE,
  INDEX `fk_registro_paciente_victima1_idx` (`victima_idvictima` ASC) VISIBLE,
  CONSTRAINT `fk_registro_paciente_hospital1`
    FOREIGN KEY (`hospital_idhospital`)
    REFERENCES `practica1s2021`.`hospital` (`idhospital`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_registro_paciente_victima1`
    FOREIGN KEY (`victima_idvictima`)
    REFERENCES `practica1s2021`.`victima` (`idvictima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`ubicacion_victima`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`ubicacion_victima` (
  `idubicacion_victima` INT NOT NULL AUTO_INCREMENT,
  `UBICACION_VCTIMA` VARCHAR(150) NULL,
  `FECHA_LLEGADA` DATETIME NULL,
  `FECHA_RETIRO` DATETIME NULL,
  `victima_idvictima` INT NOT NULL,
  PRIMARY KEY (`idubicacion_victima`),
  INDEX `fk_ubicacion_victima_victima1_idx` (`victima_idvictima` ASC) VISIBLE,
  CONSTRAINT `fk_ubicacion_victima_victima1`
    FOREIGN KEY (`victima_idvictima`)
    REFERENCES `practica1s2021`.`victima` (`idvictima`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `practica1s2021`.`temporal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `practica1s2021`.`temporal` (
  `NOMBRE_VICTIMA` VARCHAR(250) NULL,
  `APELLIDO_VICTIMA` VARCHAR(250) NULL,
  `DIRECCION_VICTIMA` VARCHAR(250) NULL,
  `FECHA_PRIMERA_SOSPECHA` VARCHAR(250) NULL,
  `FECHA_CONFIRMACION` VARCHAR(250) NULL,
  `FECHA_MUERTE` VARCHAR(250) NULL,
  `ESTADO_VICTIMA` VARCHAR(250) NULL,
  `NOMBRE_ASOCIADO` VARCHAR(250) NULL,
  `APELLIDO_ASOCIADO` VARCHAR(250) NULL,
  `FECHA_CONOCIO` VARCHAR(250) NULL,
  `CONTACTO_FISICO` VARCHAR(250) NULL,
  `FECHA_INICIO_CONTACTO` VARCHAR(250) NULL,
  `FECHA_FIN_CONTACTO` VARCHAR(250) NULL,
  `NOMBRE_HOSPITAL` VARCHAR(250) NULL,
  `DIRECCION_HOSPITAL` VARCHAR(250) NULL,
  `UBICACION_VICTIMA` VARCHAR(250) NULL,
  `FECHA_LLEGADA` VARCHAR(250) NULL,
  `FECHA_RETIRO` VARCHAR(250) NULL,
  `TRATAMIENTO` VARCHAR(250) NULL,
  `EFECTIVIDAD` VARCHAR(250) NULL,
  `FECHA_INICIO_TRATAMIENTO` VARCHAR(250) NULL,
  `FECHA_FIN_TRATAMIENTO` VARCHAR(250) NULL,
  `EFECTIVIDAD_EN_VICTIMA` VARCHAR(250) NULL)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
