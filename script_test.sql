-- Respaldo adaptado para Base de Datos en Nube (Schema: test)

SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET NAMES utf8mb4;
SET @OLD_TIME_ZONE=@@TIME_ZONE;
SET TIME_ZONE='+00:00';
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';

CREATE SCHEMA IF NOT EXISTS `test` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `test`;

DROP TABLE IF EXISTS `datos_tecnicos_acuacultura`;
CREATE TABLE `datos_tecnicos_acuacultura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitante_id` int(11) NOT NULL,
  `instalacion_propia` enum('si','no') COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `contrato_arrendamiento_anios` int(10) unsigned DEFAULT NULL COMMENT 'Años de arrendamiento. Solo si la instalación no es propia.',
  `dimensiones_unidad_produccion` text COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tipo` enum('comercial','didactica','investigacion','fomento') COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `especies` json DEFAULT NULL COMMENT 'Almacena un objeto con las especies seleccionadas y el campo "otras".',
  `tipo_instalacion` enum('granja','centro_acuicola','laboratorio') COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sistema_produccion` enum('intensivo','semi_intensivo','extensivo','hiperintensivo') COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `produccion_anual_valor` decimal(10,2) DEFAULT NULL COMMENT 'El valor numérico de la producción.',
  `produccion_anual_unidad` enum('kilogramos','toneladas','miles_toneladas') COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'La unidad de medida para la producción.',
  `certificados` json DEFAULT NULL COMMENT 'Almacena un objeto con los certificados seleccionados y sus descripciones.',
  `unidad_produccion_id` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`),
  KEY `fk_datos_acuacultura_solicitante_idx` (`solicitante_id`),
  KEY `fk_acuacultura_unidad_produccion` (`unidad_produccion_id`),
  CONSTRAINT `fk_acuacultura_unidad_produccion` FOREIGN KEY (`unidad_produccion_id`) REFERENCES `test`.`unidad_produccion` (`id`),
  CONSTRAINT `fk_datos_acuacultura_solicitante` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `datos_tecnicos_pesca`;
CREATE TABLE `datos_tecnicos_pesca` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lugar` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `localidad_captura` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `municipio_captura` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `localidad_desembarque` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `municipio_desembarque` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pesqueria` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tipo_pesqueria` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `arte_pesca` varchar(255) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `especies_objetivo` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `certificados_solicitantes` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nivel_produccion_anual` varchar(200) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `solicitante_id` int(11) DEFAULT NULL,
  `sitio_desembarque` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `solicitante_id` (`solicitante_id`),
  CONSTRAINT `datos_tecnicos_pesca_ibfk_1` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=90006;

DROP TABLE IF EXISTS `embarcaciones`;
CREATE TABLE `embarcaciones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `embarcacion_madera` tinyint(1) DEFAULT NULL,
  `embarcacion_madera_cantidad` int(11) DEFAULT NULL,
  `embarcacion_fibra_vidrio` tinyint(1) DEFAULT NULL,
  `embarcacion_fibra_vidrio_cantidad` int(11) DEFAULT NULL,
  `embarcacion_metal` tinyint(1) DEFAULT NULL,
  `embarcacion_metal_cantidad` int(11) DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `embarcaciones_menores`;
CREATE TABLE `embarcaciones_menores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_embarcacion` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `matricula` varchar(50) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tonelaje_neto` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `marca` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `numero_serie` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `potencia_hp` varchar(50) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `puerto_base` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `solicitante_id` (`solicitante_id`),
  CONSTRAINT `embarcaciones_menores_ibfk_1` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120006;

DROP TABLE IF EXISTS `equipo_transporte`;
CREATE TABLE `equipo_transporte` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transporte_lancha` tinyint(1) DEFAULT NULL,
  `transporte_lancha_cantidad` int(11) DEFAULT NULL,
  `transporte_camioneta` tinyint(1) DEFAULT NULL,
  `transporte_camioneta_cantidad` int(11) DEFAULT NULL,
  `transporte_cajafria` tinyint(1) DEFAULT NULL,
  `transporte_cajafria_cantidad` int(11) DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `instalacion_hidraulica_aireacion`;
CREATE TABLE `instalacion_hidraulica_aireacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hidraulica_bomba_agua` tinyint(1) DEFAULT NULL,
  `hidraulica_bomba_agua_cantidad` int(11) DEFAULT NULL,
  `hidraulica_aireador` tinyint(1) DEFAULT NULL,
  `hidraulica_aireador_cantidad` int(11) DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `instrumentos_medicion`;
CREATE TABLE `instrumentos_medicion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `instrumento_temperatura` tinyint(1) DEFAULT NULL,
  `instrumento_oxigeno` tinyint(1) DEFAULT NULL,
  `instrumento_ph` tinyint(1) DEFAULT NULL,
  `instrumento_otros` text COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  `instrumento_temperatura_cantidad` int(11) DEFAULT NULL,
  `instrumento_oxigeno_cantidad` int(11) DEFAULT NULL,
  `instrumento_ph_cantidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `integrantes`;
CREATE TABLE `integrantes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(150) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `rfc` varchar(18) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `curp` varchar(18) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sexo` int(11) DEFAULT NULL,
  `ultimo_grado_estudio` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `actividad_desempeña` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `localidad` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `municipio` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `telefono` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `solicitante_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `solicitante_id` (`solicitante_id`),
  CONSTRAINT `integrantes_ibfk_1` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=180006;

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expires` timestamp NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=60012;

DROP TABLE IF EXISTS `sistema_conservacion`;
CREATE TABLE `sistema_conservacion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conservacion_hielera` tinyint(1) DEFAULT NULL,
  `conservacion_hielera_cantidad` int(11) DEFAULT NULL,
  `conservacion_refrigerado` tinyint(1) DEFAULT NULL,
  `conservacion_refrigerado_cantidad` int(11) DEFAULT NULL,
  `conservacion_otros` text COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `conservacion_otros_cantidad` int(11) DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  `conservacion_cuartofrio` tinyint(1) DEFAULT NULL,
  `conservacion_cuartofrio_cantidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `solicitantes`;
CREATE TABLE `solicitantes` (
  `solicitante_id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `nombre` varchar(150) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `apellido_paterno` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `apellido_materno` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `rfc` varchar(13) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `curp` varchar(18) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `telefono` varchar(10) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `correo_electronico` varchar(50) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `nombre_representante_legal` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `actividad` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `entidad_federativa` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `municipio` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `localidad` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `colonia` varchar(15) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `codigo_postal` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `calle` varchar(150) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_exterior` varchar(150) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `no_interior` varchar(50) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `anexo1_completo` tinyint(1) NOT NULL DEFAULT '0',
  `numero_integrantes` int(11) DEFAULT NULL,
  `anexo2_completo` tinyint(1) DEFAULT '0',
  `anexo3_completo` tinyint(1) DEFAULT '0',
  `anexo4_completo` tinyint(1) DEFAULT '0',
  `anexo5_completo` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`solicitante_id`),
  UNIQUE KEY `usuario_id_UNIQUE` (`usuario_id`),
  CONSTRAINT `fk_solicitantes_usuarios` FOREIGN KEY (`usuario_id`) REFERENCES `test`.`usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=180033;

DROP TABLE IF EXISTS `tipo_estanques`;
CREATE TABLE `tipo_estanques` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitante_id` int(11) DEFAULT NULL,
  `rustico` tinyint(1) DEFAULT '0',
  `rustico_cantidad` int(11) DEFAULT NULL,
  `rustico_dimensiones` varchar(255) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `geomembrana` tinyint(1) DEFAULT '0',
  `geomembrana_cantidad` int(11) DEFAULT NULL,
  `geomembrana_dimensiones` varchar(255) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `concreto` tinyint(1) DEFAULT '0',
  `concreto_cantidad` int(11) DEFAULT NULL,
  `concreto_dimensiones` varchar(255) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `unidad_pesquera`;
CREATE TABLE `unidad_pesquera` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitante_id` int(11) DEFAULT NULL,
  `emb_madera` tinyint(1) DEFAULT NULL,
  `emb_madera_cantidad` int(11) DEFAULT NULL,
  `emb_fibra` tinyint(1) DEFAULT NULL,
  `emb_fibra_cantidad` int(11) DEFAULT NULL,
  `emb_metal` tinyint(1) DEFAULT NULL,
  `emb_metal_cantidad` int(11) DEFAULT NULL,
  `motores` tinyint(1) DEFAULT NULL,
  `motores_cantidad` int(11) DEFAULT NULL,
  `cons_hielera` tinyint(1) DEFAULT NULL,
  `cons_hielera_cantidad` int(11) DEFAULT NULL,
  `cons_refrigerador` tinyint(1) DEFAULT NULL,
  `cons_refrigerador_cantidad` int(11) DEFAULT NULL,
  `cons_cuartofrio` tinyint(1) DEFAULT NULL,
  `cons_cuartofrio_cantidad` int(11) DEFAULT NULL,
  `trans_camioneta` tinyint(1) DEFAULT NULL,
  `trans_camioneta_cantidad` int(11) DEFAULT NULL,
  `trans_cajafria` tinyint(1) DEFAULT NULL,
  `trans_cajafria_cantidad` int(11) DEFAULT NULL,
  `trans_camion` tinyint(1) DEFAULT NULL,
  `trans_camion_cantidad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `solicitante_id_idx` (`solicitante_id`),
  CONSTRAINT `fk_unidad_pesquera_solicitante` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=90006;

DROP TABLE IF EXISTS `unidad_produccion`;
CREATE TABLE `unidad_produccion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `solicitante_id` int(11) DEFAULT NULL,
  `tipo_estanque_id` int(11) DEFAULT NULL,
  `instrumento_id` int(11) DEFAULT NULL,
  `sistema_conservacion_id` int(11) DEFAULT NULL,
  `equipo_transporte_id` int(11) DEFAULT NULL,
  `embarcacion_id` int(11) DEFAULT NULL,
  `instalacion_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `solicitante_id_UNIQUE` (`solicitante_id`),
  KEY `fk_unidad_produccion_estanques` (`tipo_estanque_id`),
  KEY `fk_unidad_produccion_instrumentos` (`instrumento_id`),
  KEY `fk_unidad_produccion_conservacion` (`sistema_conservacion_id`),
  KEY `fk_unidad_produccion_transporte` (`equipo_transporte_id`),
  KEY `fk_unidad_produccion_embarcaciones_acu` (`embarcacion_id`),
  KEY `fk_unidad_produccion_hidraulica` (`instalacion_id`),
  CONSTRAINT `fk_unidad_produccion_conservacion` FOREIGN KEY (`sistema_conservacion_id`) REFERENCES `test`.`sistema_conservacion` (`id`),
  CONSTRAINT `fk_unidad_produccion_embarcaciones_acu` FOREIGN KEY (`embarcacion_id`) REFERENCES `test`.`embarcaciones` (`id`),
  CONSTRAINT `fk_unidad_produccion_estanques` FOREIGN KEY (`tipo_estanque_id`) REFERENCES `test`.`tipo_estanques` (`id`),
  CONSTRAINT `fk_unidad_produccion_hidraulica` FOREIGN KEY (`instalacion_id`) REFERENCES `test`.`instalacion_hidraulica_aireacion` (`id`),
  CONSTRAINT `fk_unidad_produccion_instrumentos` FOREIGN KEY (`instrumento_id`) REFERENCES `test`.`instrumentos_medicion` (`id`),
  CONSTRAINT `fk_unidad_produccion_solicitante` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_unidad_produccion_transporte` FOREIGN KEY (`equipo_transporte_id`) REFERENCES `test`.`equipo_transporte` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=120014;

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `curp` varchar(18) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `creado_en` datetime DEFAULT CURRENT_TIMESTAMP,
  `token_restablecimiento` varchar(100) COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `solicitante_id` int(11) DEFAULT NULL,
  `rol` enum('solicitante','superadmin','admin') COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'solicitante',
  PRIMARY KEY (`id`),
  UNIQUE KEY `curp_UNIQUE` (`curp`),
  KEY `fk_usuarios_solicitantes` (`solicitante_id`),
  CONSTRAINT `fk_usuarios_solicitantes` FOREIGN KEY (`solicitante_id`) REFERENCES `test`.`solicitantes` (`solicitante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci AUTO_INCREMENT=180037;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
