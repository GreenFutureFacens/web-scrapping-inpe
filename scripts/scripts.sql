-- MySQL Script generated by MySQL Workbench
-- Thu Sep 12 16:47:15 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema focos
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema focos
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `focos` DEFAULT CHARACTER SET utf8 ;
USE `focos` ;

-- -----------------------------------------------------
-- Table `focos`.`cadastro_unidade_federativa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`cadastro_unidade_federativa` (
  `cd_uf` INT NOT NULL,
  `sg_uf` VARCHAR(2) NOT NULL,
  `nm_uf` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`cd_uf`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `focos`.`cadastro_municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`cadastro_municipio` (
  `cd_municipio` VARCHAR(7) NOT NULL,
  `nm_municipio` VARCHAR(80) NOT NULL,
  `cd_uf` INT NOT NULL,
  PRIMARY KEY (`cd_municipio`),
  INDEX `fk_uf_municipio_idx` (`cd_uf` ASC) VISIBLE,
  CONSTRAINT `fk_uf_municipio`
    FOREIGN KEY (`cd_uf`)
    REFERENCES `focos`.`cadastro_unidade_federativa` (`cd_uf`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `focos`.`foco_queimada_municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`foco_queimada_municipio` (
  `cd_municipio` VARCHAR(7) NOT NULL,
  `dt_foco` DATETIME NOT NULL,
  `nr_longitude` FLOAT NOT NULL,
  `nr_latitude` FLOAT NOT NULL,
  INDEX `idx_cd_municipio` (`cd_municipio` ASC) VISIBLE,
  INDEX `idx_dt_foco` (`dt_foco` ASC) VISIBLE,
  CONSTRAINT `fk_municipio`
    FOREIGN KEY (`cd_municipio`)
    REFERENCES `focos`.`cadastro_municipio` (`cd_municipio`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `focos`.`cadastro_oficial_civil`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`cadastro_oficial_civil` (
  `id_oficial_civil` INT NOT NULL AUTO_INCREMENT,
  `nm_oficial_civil` VARCHAR(45) NOT NULL,
  `nr_telefone` VARCHAR(15) NULL,
  `cd_municipio` VARCHAR(7) NULL,
  PRIMARY KEY (`id_oficial_civil`),
  INDEX `fk_civil_municipio_idx` (`cd_municipio` ASC) VISIBLE,
  CONSTRAINT `fk_civil_municipio`
    FOREIGN KEY (`cd_municipio`)
    REFERENCES `focos`.`cadastro_municipio` (`cd_municipio`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

USE `focos` ;

-- -----------------------------------------------------
-- Placeholder table for view `focos`.`vw_foco_por_municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`vw_foco_por_municipio` (`cd_municipio` INT, `nm_municipio` INT, `qt_foco` INT);

-- -----------------------------------------------------
-- Placeholder table for view `focos`.`vw_foco_queimada_por_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`vw_foco_queimada_por_data` (`dt_foco` INT, `qt_foco` INT);

-- -----------------------------------------------------
-- Placeholder table for view `focos`.`vw_foco_por_municipio_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `focos`.`vw_foco_por_municipio_data` (`cd_municipio` INT, `nm_municipio` INT, `dt_foco` INT, `qt_foco` INT);

-- -----------------------------------------------------
-- View `focos`.`vw_foco_por_municipio`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `focos`.`vw_foco_por_municipio`;
USE `focos`;
CREATE  OR REPLACE VIEW `vw_foco_por_municipio` AS
select mun.cd_municipio,mun.nm_municipio, count(*) qt_foco
from foco_queimada_municipio fqm 
join cadastro_municipio mun on fqm.cd_municipio = mun.cd_municipio
group by mun.cd_municipio,mun.nm_municipio;

-- -----------------------------------------------------
-- View `focos`.`vw_foco_queimada_por_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `focos`.`vw_foco_queimada_por_data`;
USE `focos`;
CREATE  OR REPLACE VIEW `vw_foco_queimada_por_data` AS
select cast(dt_foco as date) dt_foco, count(*) qt_foco
from foco_queimada_municipio fqm 
group by cast(dt_foco as date);

-- -----------------------------------------------------
-- View `focos`.`vw_foco_por_municipio_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `focos`.`vw_foco_por_municipio_data`;
USE `focos`;
CREATE  OR REPLACE VIEW `vw_foco_por_municipio_data` AS
select mun.cd_municipio,mun.nm_municipio, fqm.dt_foco, count(*) qt_foco
from foco_queimada_municipio fqm 
join cadastro_municipio mun on fqm.cd_municipio = mun.cd_municipio
group by mun.cd_municipio,mun.nm_municipio,fqm.dt_foco;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
