---------------------------INICIO SCRIPT script_creacion_BI---------------------

--USAR DATABASE GD2C2023
USE GD2C2023
GO
-------------------------------CREACION DIMENSIONES----------------------------------------

CREATE PROCEDURE LOS_BORBOTONES.creacionDatosBI
AS
BEGIN
	CREATE TABLE LOS_BORBOTONES.BI_D_TIEMPO (
		tiempo_anio numeric(18,0) NOT NULL,
		tiempo_cuatri numeric(18,0) NOT NULL,
		tiempo_mes numeric(18,0) NOT NULL,
		PRIMARY KEY(tiempo_anio, tiempo_cuatri, tiempo_mes)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Provincia (
		provincia_codigo numeric(18,0)  PRIMARY KEY NOT NULL,
		provincia_detalle nvarchar(50)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Localidad (
		localidad_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		localidad_provincia numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Provincia(provincia_codigo),
		localidad_detalle nvarchar(50)
	)

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

	CREATE TABLE LOS_BORBOTONES.BI_D_RangoM2 (
		rangoM2_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		rangoM2_Inicio numeric(18,0),
		rangoM2_Fin numeric(18,0)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_TipoOperacion (
		tipoOperacion_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		tipoOperacion_detalle nvarchar(100)
	)

	CREATE TABLE LOS_BORBOTONES.BI_D_Moneda (
		moneda_codigo numeric(18,0) PRIMARY KEY NOT NULL,
		moneda_detalle nvarchar(100)
	)

	------------------------------------------CREACION TABLAS DE HECHOS-----------------------------------------------------

	--CREACION TABLA DE HECHOS DE LOS ANUNCIOS
	CREATE TABLE LOS_BORBOTONES.BI_TH_Anuncio (
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
		anuncio_duracion_en_dias numeric(18,0), 
		anuncio_comision_promedio numeric(18,2),
		anuncio_cantidad_anuncios numeric(18,0),
		cant_operaciones_concretadas numeric(18,0),
		monto_total_operaciones_concretadas numeric(18,0),
		PRIMARY KEY(anuncio_tipoOperacion, anuncio_moneda, anuncio_ambientes,anuncio_tipo_inmueble,
		anuncio_rango_metros_cuadrados,anuncio_rango_etario_agente,anuncio_anio_publicacion,
		anuncio_cuatrimestre_publicacion,anuncio_mes_publicacion,anuncio_barrio,anuncio_sucursal)    	
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Anuncio
	ADD CONSTRAINT FK_Tiempo_Anuncio FOREIGN KEY (anuncio_anio_publicacion, anuncio_cuatrimestre_publicacion, anuncio_mes_publicacion) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes)

	--CREACION TABLA DE HECHOS DE LOS ALQUILERES
	CREATE TABLE LOS_BORBOTONES.BI_TH_Alquiler (
		alquiler_rango_etario_inquilino numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoEtario(rangoEtario_codigo),
		alquiler_barrio numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Barrio(barrio_codigo),
		alquiler_anio_inicio numeric(18,0),
		alquiler_cuatrimestre_inicio numeric(18,0),
		alquiler_mes_inicio numeric(18,0),
		alquiler_comision numeric(18,0),
		PRIMARY KEY(alquiler_rango_etario_inquilino,alquiler_barrio,alquiler_anio_inicio,
		alquiler_cuatrimestre_inicio, alquiler_mes_inicio)
	)
	ALTER TABLE LOS_BORBOTONES.BI_TH_Alquiler
	ADD CONSTRAINT FK_Tiempo_Alquiler FOREIGN KEY (alquiler_anio_inicio, alquiler_cuatrimestre_inicio, alquiler_mes_inicio) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes)

	--CREACION TABLA DE HECHOS DE LAS VENTAS
	CREATE TABLE LOS_BORBOTONES.BI_TH_Ventas (
		venta_moneda numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Moneda(moneda_codigo) NOT NULL,
		venta_localidad numeric (18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Localidad(localidad_codigo) NOT NULL,
		venta_tipo_inmueble numeric (18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_TipoInmueble(tipo_inmueble_codigo) NOT NULL,
		venta_anio_inicio numeric(18,0),
		venta_cuatrimestre_inicio numeric(18,0),
		venta_mes_inicio numeric(18,0),
		venta_precio_promedio_m2 numeric(18,2),
		venta_cantidad_ventas numeric (18,0)
		PRIMARY KEY(venta_moneda,venta_localidad,venta_tipo_inmueble,venta_anio_inicio,venta_cuatrimestre_inicio,venta_mes_inicio)
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Ventas
	ADD CONSTRAINT FK_Tiempo_Ventas FOREIGN KEY (venta_anio_inicio, venta_cuatrimestre_inicio, venta_mes_inicio) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes)

	--CREACION TABLA DE HECHOS DE PAGO ALQUILER
	CREATE TABLE LOS_BORBOTONES.BI_TH_PagoAlquiler (
		pagoalquiler_anio_pago numeric(18,0),
		pagoalquiler_cuatrimestre_pago numeric(18,0),
		pagoalquiler_mes_pago numeric(18,0),
		pagoalquiler_cant_pagos numeric(18,0),
		pagoalquiler_porcentaje_incumplimiento numeric(18,2),
		pagoalquiler_porcentaje_aumento numeric(18,2)
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_PagoAlquiler
	ADD CONSTRAINT FK_Tiempo_PagoAlquiler FOREIGN KEY (pagoalquiler_anio_pago, pagoalquiler_cuatrimestre_pago, pagoalquiler_mes_pago) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes)
END
GO

EXEC LOS_BORBOTONES.creacionDatosBI
GO

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
    DECLARE @mes numeric(18,0)
    DECLARE @cuatrimestre numeric(18,0)

    SET @mes = MONTH(@fecha)

    SET @cuatrimestre = 
        CASE 
            WHEN @mes BETWEEN 1 AND 4 THEN 1
            WHEN @mes BETWEEN 5 AND 8 THEN 2
            WHEN @mes BETWEEN 9 AND 12 THEN 3
            ELSE 0  
        END

    RETURN @cuatrimestre
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
        SET @rangoEtarioID = 1
    ELSE IF @edad <= 35
        SET @rangoEtarioID = 2
    ELSE IF @edad <= 50
        SET @rangoEtarioID = 3
    ELSE
        SET @rangoEtarioID = 4

    RETURN @rangoEtarioID
END
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
	SELECT * FROM LOS_BORBOTONES.barrio

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

	--MIGRACIÓN BI_TH_Anuncio
	INSERT INTO LOS_BORBOTONES.BI_TH_Anuncio
		(anuncio_anio_publicacion,
		anuncio_cuatrimestre_publicacion,
		anuncio_mes_publicacion,
		anuncio_tipoOperacion,
		anuncio_moneda,
		anuncio_ambientes,
		anuncio_tipo_inmueble,
		anuncio_rango_metros_cuadrados,
		anuncio_barrio,
		anuncio_precioPromedio, 
		anuncio_duracion_en_dias,
		anuncio_rango_etario_agente, 
		anuncio_sucursal,
		anuncio_comision_promedio,
		anuncio_cantidad_anuncios,
		cant_operaciones_concretadas,
		monto_total_operaciones_concretadas)
	SELECT 
		YEAR(a.anuncio_fechaPublicacion) AS 'Anio de inicio',
		LOS_BORBOTONES.Cuatrimestre(a.anuncio_fechaPublicacion) AS 'Cuatrimestre de inicio',
		MONTH(a.anuncio_fechaPublicacion) AS 'Mes de inicio',
		a.anuncio_tipoOperacion AS 'Tipo operacion', 
		a.anuncio_moneda AS 'Tipo moneda',
		inmueble_ambientes AS 'Cantidad de ambientes',
		inmueble_tipo AS 'Tipo de inmueble',
		LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie) AS 'Rango M2',
		inmueble_barrio AS 'Barrio del anuncio',
		AVG(a.anuncio_precioPublicado) AS 'Precio promedio',
		AVG(DATEDIFF(DAY, a.anuncio_fechaPublicacion, a.anuncio_fechaFinalizacion)) AS 'Cant dias publicacion-finalizacion',
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento) AS 'Rango Etario del agente',
		agente_sucursal AS 'Sucursal donde fue publicado el anuncio' ,
		AVG(ISNULL((CASE WHEN anuncio_tipoOperacion < 3 THEN alq.alquiler_comision WHEN anuncio_tipoOperacion = 3 THEN v.venta_comision ELSE 0 END),0)) AS 'Promedio Comision',
		COUNT(*) AS 'Cantidad Anuncios',
		SUM(CASE WHEN alq.alquiler_codigo IS NOT NULL OR v.venta_codigo IS NOT NULL THEN 1 ELSE 0 END) AS 'Cantidad operaciones concretadas',
		SUM(CASE WHEN alq.alquiler_codigo IS NOT NULL OR v.venta_codigo IS NOT NULL THEN a.anuncio_precioPublicado ELSE 0 END) AS 'Monto total operaciones concretadas'
	FROM LOS_BORBOTONES.anuncio a
	JOIN LOS_BORBOTONES.inmueble ON inmueble_codigo = anuncio_inmueble
	JOIN LOS_BORBOTONES.Moneda ON anuncio_moneda = moneda_codigo
	JOIN LOS_BORBOTONES.barrio ON inmueble_barrio = barrio_codigo
	JOIN LOS_BORBOTONES.agente ON agente_codigo = anuncio_agente 
	JOIN LOS_BORBOTONES.persona ON agente_persona = persona_codigo
	LEFT JOIN LOS_BORBOTONES.Venta v ON a.anuncio_codigo = v.venta_anuncio
    LEFT JOIN LOS_BORBOTONES.Alquiler alq ON a.anuncio_codigo = alq.alquiler_anuncio_codigo
	GROUP BY YEAR(a.anuncio_fechaPublicacion),
		LOS_BORBOTONES.Cuatrimestre(a.anuncio_fechaPublicacion) ,
		MONTH(a.anuncio_fechaPublicacion),
        inmueble_barrio,
		agente_sucursal,
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
		inmueble_tipo,
        inmueble_ambientes,
        LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie),
		anuncio_tipoOperacion,
        anuncio_moneda

	--MIGRACIÓN BI_TH_Alquiler
	INSERT INTO LOS_BORBOTONES.BI_TH_Alquiler 
		(alquiler_rango_etario_inquilino,
		alquiler_barrio,
		alquiler_anio_inicio,
		alquiler_cuatrimestre_inicio,
		alquiler_mes_inicio,
		alquiler_comision)
	SELECT 
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
		inmueble_barrio,
		YEAR(alqui.alquiler_fecha_inicio),
		LOS_BORBOTONES.Cuatrimestre(alqui.alquiler_fecha_inicio),
		MONTH(alqui.alquiler_fecha_inicio),
		AVG(alqui.alquiler_comision)
	FROM LOS_BORBOTONES.alquiler alqui
	JOIN LOS_BORBOTONES.inquilino ON alquiler_codigo = inquilino_alquiler
	JOIN LOS_BORBOTONES.persona ON inquilino_persona = persona_codigo
	JOIN LOS_BORBOTONES.anuncio ON alquiler_anuncio_codigo = anuncio_codigo
	JOIN LOS_BORBOTONES.inmueble ON inmueble_codigo = anuncio_inmueble
	GROUP BY YEAR(alqui.alquiler_fecha_inicio),
	LOS_BORBOTONES.Cuatrimestre(alqui.alquiler_fecha_inicio),
	MONTH(alqui.alquiler_fecha_inicio),
	LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
	inmueble_barrio
	
	--MIGRACIÓN BI_TH_PagoAlquiler
	INSERT INTO LOS_BORBOTONES.BI_TH_PagoAlquiler
		(pagoalquiler_anio_pago,
		pagoalquiler_cuatrimestre_pago,
		pagoalquiler_mes_pago,
		pagoalquiler_porcentaje_incumplimiento,
		pagoalquiler_cant_pagos,
		pagoalquiler_porcentaje_aumento)	
	SELECT YEAR(pagoactual.pagoAlquiler_fechaPago) AS 'Año de pago',
		LOS_BORBOTONES.Cuatrimestre(pagoactual.pagoAlquiler_fechaPago) AS 'Cuatrimestre de pago',
		MONTH(pagoactual.pagoAlquiler_fechaPago) AS 'Mes de pago',
		SUM(CASE WHEN (DATEDIFF(DAY, pagoactual.pagoAlquiler_fechaPago, pagoactual.pagoAlquiler_fechaFinPeriodo) < 0) THEN 1 ELSE 0 END) / COUNT(*) * 100 AS 'Porcentaje Incumplimiento',
		COUNT(*) AS 'Cantidad de pagos',
		SUM((pagoactual.pagoAlquiler_importe - pagoanterior.pagoAlquiler_importe)/pagoanterior.pagoAlquiler_importe*100)/ COUNT(*) AS 'Promedio Porcentaje Aumento'
	FROM LOS_BORBOTONES.PagoAlquiler pagoactual
	JOIN LOS_BORBOTONES.PagoAlquiler pagoanterior ON pagoanterior.pagoAlquiler_alquiler = pagoactual.pagoAlquiler_alquiler AND DATEDIFF(MONTH,pagoanterior.pagoAlquiler_fechaPago,pagoactual.pagoAlquiler_fechaPago) = 1 
	GROUP BY YEAR(pagoactual.pagoAlquiler_fechaPago),
	LOS_BORBOTONES.Cuatrimestre(pagoactual.pagoAlquiler_fechaPago),
	MONTH(pagoactual.pagoAlquiler_fechaPago)

	--MIGRACIÓN BI_TH_Ventas
	INSERT INTO LOS_BORBOTONES.BI_TH_Ventas 
		(venta_moneda,
		venta_localidad ,
		venta_tipo_inmueble,
		venta_anio_inicio,
		venta_cuatrimestre_inicio,
		venta_mes_inicio,
		venta_precio_promedio_m2,
		venta_cantidad_ventas)
	SELECT v.venta_moneda,
		barrio_localidad AS 'Barrio del inmueble vendido',
		inmueble_tipo AS 'Tipo de inmueble vendido',
		YEAR(v.venta_fecha) AS 'Año de la venta',
		LOS_BORBOTONES.Cuatrimestre(v.venta_fecha) AS 'Cuatrimestre ',
		MONTH(v.venta_fecha) AS 'Mes de la venta',
		AVG(v.venta_precio / LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie)) 'precio promedio por Metro Cuadrado',
		count(distinct v.venta_codigo) as 'Cantidad de ventas'
	FROM LOS_BORBOTONES.Venta v
	JOIN LOS_BORBOTONES.Anuncio ON anuncio_codigo = v.venta_anuncio
	JOIN LOS_BORBOTONES.Inmueble ON anuncio_inmueble = inmueble_codigo 
	JOIN LOS_BORBOTONES.Barrio ON barrio_codigo = inmueble_barrio
	GROUP BY v.venta_moneda, 
		barrio_localidad,
		inmueble_tipo,
		YEAR(v.venta_fecha),
		LOS_BORBOTONES.Cuatrimestre(v.venta_fecha),
		MONTH(v.venta_fecha)
	
END
GO

EXEC LOS_BORBOTONES.migracionDatosBI
GO	

-------------------------------VISTAS-----------------------------------------

/*Vista 1: Duración promedio (en días) que se encuentran publicados los anuncios
según el tipo de operación (alquiler, venta, etc), barrio y ambientes para cada
cuatrimestre de cada año. Se consideran todos los anuncios que se dieron de alta
en ese cuatrimestre. La duración se calcula teniendo en cuenta la fecha de alta y
la fecha de finalización.*/

CREATE VIEW LOS_BORBOTONES.vista_duracion_promedio_anuncios
AS
SELECT anuncio_anio_publicacion AS 'Año publicacion anuncio',
	anuncio_cuatrimestre_publicacion AS 'Cuatrimestre publicacion anuncio',
	tipoOperacion_detalle 'Tipo Operacion',
	ambientes_detalle 'Ambientes',
	barrio_detalle AS 'Barrio donde se publico el anuncio',
	AVG(anuncio_duracion_en_dias) AS 'Duracion promedio en dias'
FROM LOS_BORBOTONES.BI_TH_Anuncio 
	JOIN LOS_BORBOTONES.BI_D_Barrio ON barrio_codigo = anuncio_barrio
	JOIN LOS_BORBOTONES.BI_D_TipoOperacion  ON anuncio_tipoOperacion = tipoOperacion_codigo
	JOIN LOS_BORBOTONES.BI_D_ambientes  ON anuncio_ambientes = ambientes_codigo
GROUP BY anuncio_anio_publicacion ,
	anuncio_cuatrimestre_publicacion,
	barrio_detalle,
	ambientes_detalle,
	tipoOperacion_detalle
GO

/*Vista 2: Precio promedio de los anuncios de inmuebles según el tipo de operación
(alquiler, venta, etc), tipo de inmueble y rango m2 para cada cuatrimestre/año.
Se consideran todos los anuncios que se dieron de alta en ese cuatrimestre. El
precio se debe expresar en el tipo de moneda que corresponda, identificando de
cuál se trata.*/

CREATE VIEW LOS_BORBOTONES.vista_precio_promedio_anuncio
AS
SELECT anuncio_anio_publicacion AS 'Año publicacion anuncio',
	anuncio_cuatrimestre_publicacion AS 'Cuatrimestre publicacion anuncio',
    tipoOperacion_detalle AS 'Tipo Operacion',
    tipo_inmueble_detalle AS 'Tipo Inmueble',
    rangoM2_Inicio AS 'Rango Inicio',
    rangoM2_Fin AS 'Rango Fin',
    moneda_detalle AS 'Moneda Detalle',
    AVG(anuncio_precioPromedio) AS 'Precio promedio'
FROM LOS_BORBOTONES.BI_TH_Anuncio 
    JOIN LOS_BORBOTONES.BI_D_TipoOperacion ON anuncio_tipoOperacion = tipoOperacion_codigo
    JOIN LOS_BORBOTONES.BI_D_TipoInmueble ON anuncio_tipo_inmueble = tipo_inmueble_codigo 
    JOIN LOS_BORBOTONES.BI_D_RangoM2 ON anuncio_rango_metros_cuadrados = rangoM2_codigo
    JOIN LOS_BORBOTONES.BI_D_Moneda ON anuncio_moneda = moneda_codigo 
GROUP BY anuncio_anio_publicacion,
    anuncio_cuatrimestre_publicacion,
    tipoOperacion_detalle,
    tipo_inmueble_detalle,
    rangoM2_Inicio,
    rangoM2_Fin,
    moneda_detalle
GO

/*Vista 3: Los 5 barrios más elegidos para alquilar en función del rango etario de los
inquilinos para cada cuatrimestre/año. Se calcula en función de los alquileres
dados de alta en dicho periodo.*/

CREATE VIEW LOS_BORBOTONES.vista_barrios_mas_elegidos_alquilar
AS
SELECT TOP (5) alquiler_anio_inicio AS 'Año publicacion anuncio',
	alquiler_cuatrimestre_inicio AS 'Cuatrimestre publicacion anuncio',
    rangoEtario_Inicio AS 'Rango etario inicio',
    rangoEtario_Fin AS 'Rango etario fin',
    barrio_detalle AS 'Barrio',
    COUNT(*) AS 'Cantidad Alquileres'
FROM LOS_BORBOTONES.BI_TH_Alquiler
    JOIN LOS_BORBOTONES.BI_D_RangoEtario ON rangoEtario_codigo = alquiler_rango_etario_inquilino
    JOIN LOS_BORBOTONES.BI_D_Barrio ON barrio_codigo = alquiler_barrio

GROUP BY alquiler_anio_inicio,
    alquiler_cuatrimestre_inicio,
    rangoEtario_Inicio,
    rangoEtario_Fin,
    barrio_detalle
ORDER BY COUNT(*) DESC
GO

/*Vista 4: Los 5 barrios más elegidos para alquilar en función del rango etario de los
inquilinos para cada cuatrimestre/año. Se calcula en función de los alquileres
dados de alta en dicho periodo.*/

CREATE VIEW LOS_BORBOTONES.vista_porcentaje_incumplimiento
AS
SELECT 
    pagoalquiler_anio_pago AS 'Año del pago',
    pagoalquiler_mes_pago AS 'Mes del pago',
	SUM(pagoalquiler_porcentaje_incumplimiento * pagoalquiler_cant_pagos) / SUM(pagoalquiler_cant_pagos) AS 'Porcentaje incumplimiento'
FROM
    LOS_BORBOTONES.BI_TH_PagoAlquiler 
GROUP BY
    pagoalquiler_anio_pago,
    pagoalquiler_mes_pago
GO

/*Vista 5: Porcentaje promedio de incremento del valor de los alquileres para los
contratos en curso por mes/anio. Se calcula tomando en cuenta el ultimo pago
con respecto al del mes en curso, unicamente de aquellos alquileres que hayan
tenido aumento y están activos.*/

CREATE VIEW LOS_BORBOTONES.porcentaje_promedio_incremento_alquileres
AS
SELECT 
    pagoalquiler_anio_pago,
    pagoalquiler_mes_pago,
    SUM(pagoalquiler_porcentaje_aumento * pagoalquiler_cant_pagos) / SUM(pagoalquiler_cant_pagos) AS 'Porcentaje promedio de incremento'
FROM
    LOS_BORBOTONES.BI_TH_PagoAlquiler 
GROUP BY
    pagoalquiler_anio_pago,
    pagoalquiler_mes_pago
GO

/*Vista 6: Precio promedio de m2 de la venta de inmuebles según el tipo de inmueble y
la localidad para cada cuatrimestre/año. Se calcula en función de las ventas
concretadas.*/

CREATE VIEW LOS_BORBOTONES.vista_precio_promedio_M2Ventas
AS
SELECT venta_anio_inicio as 'Anio de inicio',
    venta_cuatrimestre_inicio as 'Cuatrimestre de venta',
    tipo_inmueble_detalle AS 'Tipo de inmueble',
    venta_localidad as 'Localidad en donde se vendio',
    SUM(venta_precio_promedio_m2 * venta_cantidad_ventas)/SUM(venta_cantidad_ventas) AS 'Precio promedio por venta'
FROM LOS_BORBOTONES.BI_TH_Ventas
    JOIN LOS_BORBOTONES.BI_D_TipoInmueble ON venta_tipo_inmueble = tipo_inmueble_codigo
	JOIN LOS_BORBOTONES.BI_D_Moneda on venta_moneda = moneda_codigo
GROUP BY venta_anio_inicio,
    venta_cuatrimestre_inicio,
    tipo_inmueble_detalle,
    venta_localidad,
    moneda_detalle
GO

/*Vista 7: Valor promedio de la comisión según el tipo de operación (alquiler, venta, etc)
y sucursal para cada cuatrimestre/año. Se calcula en función de los alquileres y
ventas concretadas dentro del periodo.*/

CREATE VIEW LOS_BORBOTONES.vista_valor_promedio_comision
AS
SELECT tipoOperacion_detalle AS 'Tipo Operacion',
    sucursal_detalle AS 'Sucursal',
	anuncio_anio_publicacion AS 'Anio publicacion anuncio',
    anuncio_cuatrimestre_publicacion AS 'Cuatrimestre publicacion anuncio',
    SUM(anuncio_comision_promedio * anuncio_cantidad_anuncios) / SUM(anuncio_cantidad_anuncios) AS 'Valor promedio comision'
FROM LOS_BORBOTONES.BI_TH_Anuncio 
    JOIN LOS_BORBOTONES.BI_D_TipoOperacion ON anuncio_tipoOperacion = tipoOperacion_codigo
    JOIN LOS_BORBOTONES.BI_D_Sucursal ON anuncio_sucursal = sucursal_codigo
GROUP BY tipoOperacion_detalle,
    sucursal_detalle,
	anuncio_anio_publicacion,
    anuncio_cuatrimestre_publicacion
GO

/*Vista 8: Porcentaje de operaciones concretadas (tanto de alquileres como ventas) por
cada sucursal, según el rango etario de los empleados por año en función de la
cantidad de anuncios publicados en ese mismo año.*/

CREATE VIEW LOS_BORBOTONES.vista_porcentaje_operaciones_concretadas
AS
SELECT t.tiempo_anio,
	t.tiempo_cuatri,
	s.sucursal_detalle,
	r.rangoEtario_Inicio,
	r.rangoEtario_Fin,
	SUM(a.cant_operaciones_concretadas) / SUM(a.anuncio_cantidad_anuncios) * 100 AS 'Porcentaje operaciones concretadas'
FROM LOS_BORBOTONES.BI_TH_Anuncio AS a
	JOIN LOS_BORBOTONES.BI_D_TIEMPO AS t ON CONCAT(a.anuncio_anio_publicacion, a.anuncio_cuatrimestre_publicacion, a.anuncio_mes_publicacion) = CONCAT(t.tiempo_anio, t.tiempo_cuatri, t.tiempo_mes)
	JOIN LOS_BORBOTONES.Sucursal AS s ON a.anuncio_sucursal = s.sucursal_codigo
	JOIN LOS_BORBOTONES.BI_D_RangoEtario AS r ON a.anuncio_rango_etario_agente = r.rangoEtario_codigo
GROUP BY t.tiempo_anio,
	t.tiempo_cuatri,
	s.sucursal_detalle,
	r.rangoEtario_Inicio,
	r.rangoEtario_Fin
GO

/*Vista 9: Monto total de cierre de contratos por tipo de operación (tanto de alquileres
como ventas) por cada cuatrimestre y sucursal, diferenciando el tipo de moneda.*/

CREATE VIEW LOS_BORBOTONES.vista_monto_total_cierre_contratos
AS
SELECT t.tiempo_anio,
	t.tiempo_cuatri,
	s.sucursal_codigo,
	tipoO.tipoOperacion_detalle,
	tipoM.moneda_detalle,
	SUM(a.monto_total_operaciones_concretadas) AS 'Monto total cierre contratos'
FROM LOS_BORBOTONES.BI_TH_Anuncio AS a
	JOIN LOS_BORBOTONES.TipoOperacion tipoO ON a.anuncio_tipoOperacion = tipoO.tipoOperacion_codigo
	JOIN LOS_BORBOTONES.BI_D_Moneda tipoM ON a.anuncio_moneda = tipoM.moneda_codigo
	JOIN LOS_BORBOTONES.BI_D_TIEMPO AS t ON CONCAT(a.anuncio_anio_publicacion, a.anuncio_cuatrimestre_publicacion, a.anuncio_mes_publicacion) = CONCAT(t.tiempo_anio, t.tiempo_cuatri, t.tiempo_mes)
	JOIN LOS_BORBOTONES.Sucursal AS s ON a.anuncio_sucursal = s.sucursal_codigo
WHERE
	a.anuncio_anio_publicacion IS NOT NULL AND a.anuncio_cuatrimestre_publicacion IS NOT NULL AND a.anuncio_mes_publicacion IS NOT NULL
GROUP BY
	t.tiempo_anio,
	t.tiempo_cuatri,
	s.sucursal_codigo,
	tipoO.tipoOperacion_detalle,
	tipoM.moneda_detalle
GO

---------------------------FIN SCRIPT script_creacion_BI---------------------