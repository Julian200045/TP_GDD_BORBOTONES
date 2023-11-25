-------------------INICIO SCRIPT script_creacion_inicial.sql-------------------

--USAR DATABASE GD2C2023
USE GD2C2023
GO
--CREAR ESQUEMA LOS_BORBOTONES
CREATE SCHEMA LOS_BORBOTONES
GO

-------------------------------CREACION-----------------------------------------
CREATE PROCEDURE LOS_BORBOTONES.creacionDatosBI
AS
BEGIN

CREATE TABLE BI_Tiempo(
    tiempo_anio numeric(4,0) NOT NULL,
    tiempo_cuatri numeric(1,0) NOT NULL,
    tiempo_mes numeric(2,0) NOT NULL,
    PRIMARY KEY(tiempo_anio, tiempo_cuatri, tiempo_mes)
)

CREATE TABLE BI_Ubicacion(
    ubicacion_provincia numeric(18,0) NOT NULL FOREIGN KEY REFERENCES Provincia(provincia_codigo),
    ubicacion_localidad numeric(18,0) NOT NULL FOREIGN KEY REFERENCES Localidad(localidad_codigo),
    ubicacion_barrio numeric(18,0) NOT NULL FOREIGN KEY REFERENCES Barrio(barrio_codigo),
    PRIMARY KEY(ubicacion_provincia,  ubicacion_localidad, ubicacion_barrio)
)

CREATE TABLE BI_Sucursal (
    sucursal_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    sucursal_localidad numeric(18,0) FOREIGN KEY REFERENCES Localidad(localidad_codigo),
    sucursal_detalle nvarchar(50),
    sucursal_direccion nvarchar(50),
    sucursal_telefono nvarchar(50)
)

CREATE TABLE BI_RangoEtario (
    rangoEtario_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    rangoEtario_Inicio numeric(2,0),
    rangoEtario_Fin numeric(2,0)
)

CREATE TABLE BI_TipoInmueble (
    tipo_inmueble_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    tipo_inmueble_detalle nvarchar(100)
)

CREATE TABLE BI_Ambientes (
    ambientes_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    ambientes_detalle nvarchar(50)
)

CREATE TABLE BI_RangoM2(
    rangoM2_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    rangoM2_Inicio numeric(2,0),
    rangoM2_Fin numeric(2,0)
)

CREATE TABLE BI_TipoOperacion(
    tipoOperacion_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    tipoOperacion_detalle nvarchar(100)
)

CREATE TABLE BI_Moneda (
    moneda_codigo numeric(18,0) PRIMARY KEY NOT NULL,
    moneda_detalle nvarchar(100)
)

--TABLAS DE HECHOS
CREATE TABLE Anuncio(
    
)

CREATE TABLE Alquiler(

)

CREATE TABLE Ventas(

)

END
GO

-------------------------------MIGRACION-----------------------------------------
CREATE PROCEDURE LOS_BORBOTONES.migracionDatosBI
AS
BEGIN

--MIGRACIÓN BI_Tiempo
DECLARE @anio INT = 2023
DECLARE @anio_fin INT = 2030
DECLARE @cuatrimestre INT
DECLARE @mes INT

WHILE @anio <= @anio_fin
BEGIN
  SET @cuatrimestre = 1

  WHILE @cuatrimestre <= 3
  BEGIN
    SET @mes = 1 + ((@cuatrimestre - 1) * 4)

    WHILE @mes <= @cuatrimestre * 4
    BEGIN
      INSERT INTO BI_Tiempo (tiempo_anio, tiempo_cuatri, tiempo_mes)
      VALUES (@anio, @cuatrimestre, @mes)

      SET @mes = @mes + 1
    END

    SET @cuatrimestre = @cuatrimestre + 1
  END

  SET @anio = @anio + 1
END

--MIGRACIÓN BI_Ubicacion
INSERT INTO BI_Ubicacion
SELECT provincia_codigo, localidad_codigo, barrio_codigo FROM Provincia
JOIN Localidad ON provincia_codigo = localidad_provincia
JOIN Barrio ON localidad_codigo = barrio_localidad
ORDER BY provincia_codigo, localidad_codigo, barrio_codigo

--MIGRACION BI_Sucrusal
INSERT INTO BI_Sucursal
SELECT * FROM Sucursal

--MIGRACIÓN BI_RangoEtario
INSERT INTO BI_RangoEtario 
VALUES (1,0,25),
       (2,25,35),
       (3,35,50),
       (4,50,100)

--MIGRACIÓN BI_TipoInmueble
INSERT INTO BI_TipoInmueble
SELECT * FROM TipoInmueble

--MIGRACIÓN BI_Ambientes
INSERT INTO BI_Ambientes
SELECT * FROM Ambientes

--MIGRACIÓN BI_RangoM2
INSERT INTO BI_RangoM2 
VALUES (1,0,35),
       (2,35,55),
       (3,55,75),
       (4,75,100),
       (4,100,NULL)

--MIGRACIÓN BI_TipoOperacion
INSERT INTO BI_TipoOperacion
SELECT * FROM TipoOperacion

--MIGRACIÓN BI_Moneda
INSERT INTO BI_Moneda 
SELECT * FROM Moneda

END
GO

--EJECUTAR AMBOS PROCEDIMIENTOS (CREACION-MIGRACION)
exec LOS_BORBOTONES.creacionDatosBI
exec LOS_BORBOTONES.migracionDatosBI

--VISTAS
--..................

-------------FIN SCRIPT script_creacion_BI.sql----------------


