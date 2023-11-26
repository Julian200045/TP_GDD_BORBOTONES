---------------------------INICIO SCRIPT script_creacion_BI---------------------

--USAR DATABASE GD2C2023
USE GD2C2023
GO
-------------------------------CREACION DIMENSIONES----------------------------------------

CREATE PROCEDURE LOS_BORBOTONES.creacionDatosBI
AS
BEGIN
	CREATE TABLE LOS_BORBOTONES.BI_D_TIEMPO(
		tiempo_anio numeric(18,0) NOT NULL,
		tiempo_cuatri numeric(18,0) NOT NULL,
		tiempo_mes numeric(18,0) NOT NULL,
		PRIMARY KEY(tiempo_anio, tiempo_cuatri, tiempo_mes)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Provincia (
		provincia_codigo numeric(18,0)  PRIMARY KEY NOT NULL,
		provincia_detalle nvarchar(50)
	)
	--CREAR LOCALIDAD
	CREATE TABLE LOS_BORBOTONES.BI_D_Localidad (
		localidad_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		localidad_provincia numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Provincia(provincia_codigo),
		localidad_detalle nvarchar(50)
	)
	--CREAR BARRIO
	CREATE TABLE LOS_BORBOTONES.BI_D_Barrio (
		barrio_codigo numeric(18,0)  PRIMARY KEY NOT NULL,
		barrio_localidad numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Localidad(localidad_codigo),
		barrio_detalle nvarchar(50)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Sucursal (
		sucursal_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		sucursal_localidad numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Localidad(localidad_codigo),
		sucursal_detalle nvarchar(50),
		sucursal_direccion nvarchar(50),
		sucursal_telefono nvarchar(50)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_RangoEtario (
		rangoEtario_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		rangoEtario_Inicio numeric(18,0),
		rangoEtario_Fin numeric(18,0)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_TipoInmueble (
		tipo_inmueble_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		tipo_inmueble_detalle nvarchar(100)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Ambientes (
		ambientes_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		ambientes_detalle nvarchar(50)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_RangoM2(
		rangoM2_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		rangoM2_Inicio numeric(18,0),
		rangoM2_Fin numeric(18,0)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_TipoOperacion(
		tipoOperacion_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		tipoOperacion_detalle nvarchar(100)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Moneda (
		moneda_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		moneda_detalle nvarchar(100)
	)

	------------------------------------------CREACION TABLAS DE HECHOS-----------------------------------------------------

	--CREACION TABLA DE HECHOS DE LOS ANUNCIOS
	CREATE TABLE LOS_BORBOTONES.BI_TH_Anuncio(
		anuncio_tipoOperacion numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_TipoOperacion(tipoOperacion_codigo),
		anuncio_moneda numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Moneda(moneda_codigo), 
		anuncio_ambientes numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Ambientes(ambientes_codigo), 
		anuncio_tipo_inmueble numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_TipoInmueble(tipo_inmueble_codigo), 
		anuncio_rango_metros_cuadrados numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoM2(rangoM2_codigo),
		anuncio_rango_etario_agente numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoEtario(rangoEtario_codigo), 
		anuncio_barrio numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Barrio(barrio_codigo),
		anuncio_sucursal numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Sucursal(sucursal_codigo),
		anuncio_anio_publicacion numeric(18,0),
		anuncio_cuatrimestre_publicacion numeric(18,0), 
		anuncio_mes_publicacion  numeric(18,0),
		anuncio_precioPromedio numeric(18,2),
		anuncio_duracion_en_dias numeric(18,0), --despues le harias el average este no seria foreign key
		
		PRIMARY KEY(anuncio_tipoOperacion, anuncio_moneda, anuncio_ambientes,anuncio_tipo_inmueble,
		anuncio_rango_metros_cuadrados,anuncio_anio_publicacion,anuncio_cuatrimestre_publicacion,
		anuncio_mes_publicacion,anuncio_barrio,anuncio_sucursal)    
		
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Anuncio
	ADD CONSTRAINT FK_Tiempo FOREIGN KEY (anuncio_anio_publicacion, anuncio_cuatrimestre_publicacion, anuncio_mes_publicacion) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes);


	--CREACION TABLA DE HECHOS DE LOS ALQUILERES
	/*CREATE TABLE LOS_BORBOTONES.BI_TH_Alquiler(
		alquiler_rango_etario_inquilino numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoEtario(rangoEtario_codigo),
		alquiler_anio_inicio numeric(18,0),
		alquiler_cuatrimestre_inicio numeric(18,0),
		alquiler_mes_inicio numeric(18,0),
		alquiler_cantidad_periodos numeric(18,0),
		alquiler_comision numeric(18,0),
		alquiler_barrio numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Barrio(barrio_codigo),
	   -- alquiler_porcentaje_incumplimiento numeric(18,2) , DUDOSO
	   -- alquiler_porcentaje_promedio_incremento numeric(18,2), DUDOSO

		PRIMARY KEY (alquiler_rango_etario_inquilino,alquiler_anio_inicio,alquiler_cuatrimestre_inicio)
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Alquiler
	ADD CONSTRAINT FK_Tiempo FOREIGN KEY (alquiler_anio_inicio, alquiler_cuatrimestre_inicio, alquiler_mes_publicacion) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes);

	--TABLA DE HECHOS DE LAS VENTAS
	CREATE TABLE Ventas(
		venta_moneda numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Moneda(moneda_codigo) NOT NULL,
		venta_rango_etario_inquilino numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoEtario(rangoEtario_codigo), 
		venta_anio_inicio numeric(18,0),
		venta_cuatrimestre_inicio numeric(18,0),
		venta_mes_inicio numeric(18,0),
		venta_fecha smalldatetime, 
		venta_comision numeric(18,2),
		venta_precio numeric(18,2),
		venta_cuatrimestre numeric(18,2)
		PRIMARY KEY(venta_moneda,venta_rango_etario_inquilino,venta_anio_inicio)
	)   */

END
GO

exec LOS_BORBOTONES.creacionDatosBI
go
----------------------------------FUNCIONES-----------------------------------------
CREATE FUNCTION LOS_BORBOTONES.ObtenerRangoM2(@m2 numeric(10,0))
RETURNS numeric(18,0)
AS
BEGIN
    DECLARE @rangoM2ID numeric(18,0)

    SELECT @rangoM2ID = rangoM2_codigo FROM LOS_BORBOTONES.BI_D_RangoM2
    WHERE @m2 >= rangoM2_Inicio 
	AND @m2 <= rangoM2_FIN

    RETURN @rangoM2ID
END
GO

CREATE FUNCTION LOS_BORBOTONES.Cuatrimestre (@fecha smalldatetime)
RETURNS numeric(18,0)
AS
BEGIN
    DECLARE @mes numeric(18,0);
    DECLARE @cuatrimestre numeric(18,0);

    SET @mes = MONTH(@fecha);

    SET @cuatrimestre = 
        CASE 
            WHEN @mes BETWEEN 1 AND 4 THEN 1
            WHEN @mes BETWEEN 5 AND 8 THEN 2
            WHEN @mes BETWEEN 9 AND 12 THEN 3
            ELSE 0  
        END;

    RETURN @cuatrimestre;
END
GO

CREATE FUNCTION LOS_BORBOTONES.ObtenerRangoEtario (@fechaNacimiento DATE)
RETURNS numeric(18,0)
AS
BEGIN
    DECLARE @edad numeric(18,0)
    DECLARE @rangoEtarioID numeric(18,0)
    
    SET @edad = DATEDIFF(YEAR, @fechaNacimiento, GETDATE())
    
    IF @edad <= 25
        SET @rangoEtarioID = 1;
    ELSE IF @edad <= 35
        SET @rangoEtarioID = 2;
    ELSE IF @edad <= 50
        SET @rangoEtarioID = 3;
    ELSE
        SET @rangoEtarioID = 4;

    RETURN @rangoEtarioID;
END;
GO

-------------------------------MIGRACION-----------------------------------------
CREATE PROCEDURE LOS_BORBOTONES.migracionDatosBI
AS
BEGIN
	--MIGRACIÓN BI_Tiempo
	DECLARE @anio numeric(18,0) = 2023
	DECLARE @anio_fin numeric(18,0) = 2030
	DECLARE @cuatrimestre numeric(18,0)
	DECLARE @mes numeric(18,0)

	WHILE @anio <= @anio_fin
	BEGIN
	  SET @cuatrimestre = 1

	  WHILE @cuatrimestre <= 3
	  BEGIN
		SET @mes = 1 + ((@cuatrimestre - 1) * 4)

		WHILE @mes <= @cuatrimestre * 4
		BEGIN
		  INSERT INTO LOS_BORBOTONES.BI_D_TIEMPO (tiempo_anio, tiempo_cuatri, tiempo_mes)
		  VALUES (@anio, @cuatrimestre, @mes)

		  SET @mes = @mes + 1
		END

		SET @cuatrimestre = @cuatrimestre + 1
	  END

	  SET @anio = @anio + 1
	END

	--MIGRACIÓN Ubicacion
	INSERT INTO LOS_BORBOTONES.BI_D_Provincia
	SELECT * FROM LOS_BORBOTONES.Provincia

	INSERT INTO LOS_BORBOTONES.BI_D_Localidad
	SELECT * FROM LOS_BORBOTONES.Localidad

	INSERT INTO LOS_BORBOTONES.BI_D_Barrio
	SELECT * from LOS_BORBOTONES.barrio


	--MIGRACION BI_Sucursal
	INSERT INTO LOS_BORBOTONES.BI_D_Sucursal
	SELECT * FROM LOS_BORBOTONES.Sucursal

	--MIGRACIÓN BI_RangoEtario
	INSERT INTO LOS_BORBOTONES.BI_D_RangoEtario 
	VALUES (1,0,25),
		   (2,25,35),
		   (3,35,50),
		   (4,50,100)

	--MIGRACIÓN BI_TipoInmueble
	INSERT INTO LOS_BORBOTONES.BI_D_TipoInmueble
	SELECT * FROM LOS_BORBOTONES.TipoInmueble

	--MIGRACIÓN BI_Ambientes
	INSERT INTO LOS_BORBOTONES.BI_D_Ambientes
	SELECT * FROM LOS_BORBOTONES.Ambientes

	--MIGRACIÓN BI_RangoM2
	INSERT INTO LOS_BORBOTONES.BI_D_RangoM2 
	VALUES (1,0,35),
		   (2,35,55),
		   (3,55,75),
		   (4,75,100),
		   (5,100,100000)

	--MIGRACIÓN BI_TipoOperacion
	INSERT INTO LOS_BORBOTONES.BI_D_TipoOperacion
	SELECT * FROM LOS_BORBOTONES.TipoOperacion

	--MIGRACIÓN BI_Moneda
	INSERT INTO BI_D_Moneda 
	SELECT * FROM LOS_BORBOTONES.Moneda

	--MIGRACIÓN BI_TH_anuncio
	insert into LOS_BORBOTONES.BI_TH_Anuncio
		(anuncio_tipoOperacion,
		anuncio_moneda ,
		anuncio_ambientes ,
		anuncio_tipo_inmueble ,
		anuncio_rango_metros_cuadrados ,
		anuncio_anio_publicacion ,
		anuncio_cuatrimestre_publicacion ,
		anuncio_mes_publicacion ,
		anuncio_barrio ,
		anuncio_precioPromedio, 
		anuncio_duracion_en_dias ,
		anuncio_rango_etario_agente, 
		anuncio_sucursal)
	select 
		a.anuncio_tipoOperacion as 'Tipo operacion', 
		a.anuncio_moneda as 'Tipo moneda',
		inmueble_ambientes as 'Cantidad de ambientes',
		inmueble_tipo as 'Tipo de inmueble',
		LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie) as 'Rango M2',
		year(a.anuncio_fechaPublicacion) as 'Anio de inicio',
		LOS_BORBOTONES.Cuatrimestre(a.anuncio_fechaPublicacion) as 'Cuatrimestre de inicio',
		month(a.anuncio_fechaPublicacion) as 'Mes de inicio',
		inmueble_barrio,
		avg(a.anuncio_precioPublicado) as 'Precio promedio',
		AVG(DATEDIFF(DAY, a.anuncio_fechaPublicacion, a.anuncio_fechaFinalizacion)) as 'Cant dias publicacion-finalizacion',
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento) as 'Rango Etario del agente',
		agente_sucursal as 'Sucursal donde fue publicado el anuncio' 
	from LOS_BORBOTONES.anuncio a
	join LOS_BORBOTONES.inmueble on inmueble_codigo = anuncio_inmueble
	join LOS_BORBOTONES.Moneda on anuncio_moneda = moneda_codigo
	join LOS_BORBOTONES.barrio on inmueble_barrio = barrio_codigo
	join LOS_BORBOTONES.agente on agente_codigo = anuncio_agente 
	join LOS_BORBOTONES.persona on agente_persona = persona_codigo
	group by
		year(a.anuncio_fechaPublicacion),
		LOS_BORBOTONES.Cuatrimestre(a.anuncio_fechaPublicacion) ,
		month(a.anuncio_fechaPublicacion),
        inmueble_barrio,
        agente_sucursal,
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
		inmueble_tipo,
        inmueble_ambientes,
        LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie),
        inmueble_codigo,
		anuncio_tipoOperacion,
        anuncio_moneda;
END

GO

exec LOS_BORBOTONES.migracionDatosBI

GO	

--------------------------------------------------------VISTAS---------------------------------------------------------

CREATE VIEW LOS_BORBOTONES.VistaDuracionPromedioAnuncios
AS
	SELECT 
		a.anuncio_anio_publicacion as 'Año publicacion anuncio',
		a.anuncio_cuatrimestre_publicacion as 'Cuatrimestre publicacion anuncio',
		bar.barrio_detalle as 'Barrio donde se publico el anuncio',
		ambi.ambientes_detalle 'Ambientes',
		tipoOp.tipoOperacion_detalle 'Tipo Operacion',
		avg(anuncio_duracion_en_dias) AS 'Duracion promedio en dias'
	FROM
		LOS_BORBOTONES.BI_TH_Anuncio a
		JOIN LOS_BORBOTONES.BI_D_Barrio bar ON bar.barrio_codigo = a.anuncio_barrio
		JOIN LOS_BORBOTONES.BI_D_TipoOperacion tipoOp ON a.anuncio_tipoOperacion = tipoOp.tipoOperacion_codigo
		JOIN LOS_BORBOTONES.BI_D_ambientes ambi ON a.anuncio_ambientes = ambi.ambientes_codigo
	GROUP BY
		a.anuncio_anio_publicacion ,
		a.anuncio_cuatrimestre_publicacion,
		bar.barrio_detalle,
		ambi.ambientes_detalle,
		tipoOp.tipoOperacion_detalle
GO





---------------------------INICIO SCRIPT script_creacion_BI---------------------


