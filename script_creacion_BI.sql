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
		anuncio_codigo numeric(19,0) IDENTITY(1,1),
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
		anuncio_comision_promedio numeric(18,2),
		anuncio_cantidad_anuncios numeric(18,0)
		PRIMARY KEY(anuncio_codigo,anuncio_tipoOperacion, anuncio_moneda, anuncio_ambientes,anuncio_tipo_inmueble,
		anuncio_rango_metros_cuadrados,anuncio_anio_publicacion,anuncio_cuatrimestre_publicacion,
		anuncio_mes_publicacion,anuncio_barrio,anuncio_sucursal)    
		
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Anuncio
	ADD CONSTRAINT FK_Tiempo_Anuncio FOREIGN KEY (anuncio_anio_publicacion, anuncio_cuatrimestre_publicacion, anuncio_mes_publicacion) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes);


	--CREACION TABLA DE HECHOS DE LOS ALQUILERES
	CREATE TABLE LOS_BORBOTONES.BI_TH_Alquiler(
		alquiler_rango_etario_inquilino numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_RangoEtario(rangoEtario_codigo),
		alquiler_barrio numeric(18,0) FOREIGN KEY REFERENCES LOS_BORBOTONES.BI_D_Barrio(barrio_codigo),
		alquiler_anio_inicio numeric(18,0),
		alquiler_cuatrimestre_inicio numeric(18,0),
		alquiler_mes_inicio numeric(18,0),
		alquiler_comision numeric(18,0),
	
	   -- alquiler_porcentaje_incumplimiento numeric(18,2) , DUDOSO
	   -- alquiler_porcentaje_promedio_incremento numeric(18,2), DUDOSO

		PRIMARY KEY (alquiler_rango_etario_inquilino,alquiler_barrio,alquiler_anio_inicio,
		alquiler_cuatrimestre_inicio, alquiler_mes_inicio)
	)

	ALTER TABLE LOS_BORBOTONES.BI_TH_Alquiler
	ADD CONSTRAINT FK_Tiempo_Alquiler FOREIGN KEY (alquiler_anio_inicio, alquiler_cuatrimestre_inicio, alquiler_mes_inicio) 
	REFERENCES LOS_BORBOTONES.BI_D_TIEMPO(tiempo_anio, tiempo_cuatri, tiempo_mes);

	
	--TABLA DE HECHOS DE LAS VENTAS
	CREATE TABLE LOS_BORBOTONES.BI_TH_Ventas(
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
	)   

	--TABLA DE HECHOS PAGO VENTA
	create table LOS_BORBOTONES.BI_TH_PagoAlquiler (
		pagoalquiler_anio_pago numeric(18,0),
		pagoalquiler_mes_pago numeric(18,0),
		pagoalquiler_porcentaje_incumplimiento numeric(18,2),
		pagoalquiler_cant_pagos numeric(18,0),
		pagoalquiler_porcentaje_aumento numeric(18,2)
	)
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
		anuncio_cantidad_anuncios)
	select 
		year(a.anuncio_fechaPublicacion) as 'Anio de inicio',
		LOS_BORBOTONES.Cuatrimestre(a.anuncio_fechaPublicacion) as 'Cuatrimestre de inicio',
		month(a.anuncio_fechaPublicacion) as 'Mes de inicio',
		a.anuncio_tipoOperacion as 'Tipo operacion', 
		a.anuncio_moneda as 'Tipo moneda',
		inmueble_ambientes as 'Cantidad de ambientes',
		inmueble_tipo as 'Tipo de inmueble',
		LOS_BORBOTONES.ObtenerRangoM2(inmueble_superficie) as 'Rango M2',
		inmueble_barrio as 'Barrio del anuncio',
		avg(a.anuncio_precioPublicado) as 'Precio promedio',
		AVG(DATEDIFF(DAY, a.anuncio_fechaPublicacion, a.anuncio_fechaFinalizacion)) as 'Cant dias publicacion-finalizacion',
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento) as 'Rango Etario del agente',
		agente_sucursal as 'Sucursal donde fue publicado el anuncio' ,
		AVG( case when anuncio_tipoOperacion = 3 then (select venta_comision from venta where anuncio_codigo = venta_anuncio)
		else (select alquiler_comision from alquiler where anuncio_codigo = alquiler_anuncio_codigo) end ) as 'Promedio comision',
		count(*) as 'Cantidad Anuncios'
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
		anuncio_tipoOperacion,
        anuncio_moneda;

	INSERT INTO LOS_BORBOTONES.BI_TH_Alquiler 
		(alquiler_rango_etario_inquilino,
		alquiler_barrio,
		alquiler_anio_inicio,
		alquiler_cuatrimestre_inicio,
		alquiler_mes_inicio,
		alquiler_comision)
	select 
		LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
		inmueble_barrio,
		year(alqui.alquiler_fecha_inicio),
		LOS_BORBOTONES.Cuatrimestre(alqui.alquiler_fecha_inicio),
		month(alqui.alquiler_fecha_inicio),
		avg(alqui.alquiler_comision)
	from LOS_BORBOTONES.alquiler alqui
	join LOS_BORBOTONES.inquilino on alquiler_codigo = inquilino_alquiler
	join LOS_BORBOTONES.persona on inquilino_persona = persona_codigo
	join LOS_BORBOTONES.anuncio on alquiler_anuncio_codigo = anuncio_codigo
	join LOS_BORBOTONES.inmueble on inmueble_codigo = anuncio_inmueble
		group by year(alqui.alquiler_fecha_inicio),
	LOS_BORBOTONES.Cuatrimestre(alqui.alquiler_fecha_inicio),
	month(alqui.alquiler_fecha_inicio),
	LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento),
	inmueble_barrio
	
	INSERT INTO LOS_BORBOTONES.BI_TH_PagoAlquiler
		(pagoalquiler_anio_pago,
		pagoalquiler_mes_pago,
		pagoalquiler_porcentaje_incumplimiento,
		pagoalquiler_cant_pagos,
		pagoalquiler_porcentaje_aumento)
		
	select year(pagoactual.pagoAlquiler_fechaPago) as 'Año de pago',
		month(pagoactual.pagoAlquiler_fechaPago) as 'Mes de pago',
		sum(case when (datediff(day, pagoactual.pagoAlquiler_fechaPago, pagoactual.pagoAlquiler_fechaFinPeriodo) < 0) then 1 else 0 END) / COUNT(*) * 100 as 'Porcentaje Incumplimiento',
		count(*) as 'Cantidad de pagos',
		SUM((pagoactual.pagoAlquiler_importe - pagoanterior.pagoAlquiler_importe)/pagoanterior.pagoAlquiler_importe*100)/ COUNT(*) AS 'Promedio Porcentaje Aumento'
		
	from LOS_BORBOTONES.PagoAlquiler pagoactual
	JOIN LOS_BORBOTONES.PagoAlquiler pagoanterior ON pagoanterior.pagoAlquiler_alquiler = pagoactual.pagoAlquiler_alquiler and datediff(month,pagoanterior.pagoAlquiler_fechaPago,pagoactual.pagoAlquiler_fechaPago) = 1 
	group by year(pagoactual.pagoAlquiler_fechaPago),
	 month(pagoactual.pagoAlquiler_fechaPago)

/*
	INSERT INTO LOS_BORBOTONES.BI_TH_Ventas 
		(venta_moneda,
		--venta_rango_etario_inquilino,
		venta_anio_inicio,
		venta_cuatrimestre_inicio ,
		venta_mes,
		venta_fecha,
		venta_comision,
		venta_precio, 
		venta_cuatrimestre,
		venta_precio_promedio,
		venta_inmueble_detalle,
		venta_re_agente)
	
	select 
	v.venta_moneda,
	v.venta_fecha as 'fecha',
	LOS_BORBOTONES.Cuatrimestre(v.venta_fecha) as 'Cuatrimestre ',
	avg(v.venta_Comision) as 'Comision de la venta',
	avg(v.venta_total_precio_m2) as 'total precio en m2',
	month(v.venta_fecha) as 'Mes de la venta',
	tipoInmueble_detalle as 'Tipo de inmueble vendido',
	barrio_localidad as 'Barrio del inmueble vendido',
	avg(v.precio_venta / LOS_BORBOTONES.ObtenerRangoM2( inmueble_superficie)) 'precio promedio por Metro Cuadrado',
	LOS_BORBOTONES.ObtenerRangoEtario(persona_fecha_nacimiento) as 'Rango etario del agente'

	
	from LOS_BORBOTONES.Venta v
	join LOS_BORBOTONES.Anuncio on anuncio_codigo = v.venta_anuncio
	join LOS_BORBOTONES.Inmueble on anuncio_inmueble = inmueble_codigo 
	join LOS_BORBOTONES.Barrio on barrio_codigo = inmueble_barrio
	join LOS_BORBOTONES.agente on agente_codigo = anuncio_agente
	join LOS_BORBOTONES.persona on persona_codigo = agente_persona  
	join LOS_BORBOTONES.tipoInmueble on tipoInmueble_codigo = inmueble_tipo
	--group by LOS_BORBOTONES.Cuatrimestre(v.venta_fecha), year(v.venta_fecha)
*/

END
GO

exec LOS_BORBOTONES.migracionDatosBI

GO	

--------------------------------------------------------VISTAS---------------------------------------------------------
/*Vista 1: Duración promedio (en días) que se encuentran publicados los anuncios
según el tipo de operación (alquiler, venta, etc), barrio y ambientes para cada
cuatrimestre de cada año. Se consideran todos los anuncios que se dieron de alta
en ese cuatrimestre. La duración se calcula teniendo en cuenta la fecha de alta y
la fecha de finalización.*/

CREATE VIEW LOS_BORBOTONES.vista_duracion_promedio_anuncios
AS
	SELECT anuncio_anio_publicacion as 'Año publicacion anuncio',
		anuncio_cuatrimestre_publicacion as 'Cuatrimestre publicacion anuncio',
		tipoOperacion_detalle 'Tipo Operacion',
		ambientes_detalle 'Ambientes',
		barrio_detalle as 'Barrio donde se publico el anuncio',
		avg(anuncio_duracion_en_dias) AS 'Duracion promedio en dias'
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
SELECT anuncio_anio_publicacion as 'Año publicacion anuncio',
	anuncio_cuatrimestre_publicacion as 'Cuatrimestre publicacion anuncio',
    tipoOperacion_detalle as 'Tipo Operacion',
    tipo_inmueble_detalle AS 'Tipo Inmueble',
    rangoM2_Inicio AS 'Rango Inicio',
    rangoM2_Fin AS 'Rango Fin',
    moneda_detalle AS 'Moneda Detalle',
    avg(anuncio_precioPromedio) AS 'Precio promedio'

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
SELECT TOP (5) alquiler_anio_inicio as 'Año publicacion anuncio',
	alquiler_cuatrimestre_inicio as 'Cuatrimestre publicacion anuncio',
    rangoEtario_Inicio as 'Rango etario inicio',
    rangoEtario_Fin as 'Rango etario fin',
    barrio_detalle as 'Barrio',
    count(*) AS 'Cantidad Alquileres'
FROM LOS_BORBOTONES.BI_TH_Alquiler
    JOIN LOS_BORBOTONES.BI_D_RangoEtario ON rangoEtario_codigo = alquiler_rango_etario_inquilino
    JOIN LOS_BORBOTONES.BI_D_Barrio ON barrio_codigo = alquiler_barrio

GROUP BY alquiler_anio_inicio,
    alquiler_cuatrimestre_inicio,
    rangoEtario_Inicio,
    rangoEtario_Fin,
    barrio_detalle
ORDER BY count(*) DESC
GO

/*Vista 4: Los 5 barrios más elegidos para alquilar en función del rango etario de los
inquilinos para cada cuatrimestre/año. Se calcula en función de los alquileres
dados de alta en dicho periodo.*/

CREATE VIEW LOS_BORBOTONES.vista_porcentaje_incumplimiento
AS
SELECT 
    pagoalquiler_anio_pago as 'Año del pago',
    pagoalquiler_mes_pago as 'Mes del pago',
	SUM(pagoalquiler_porcentaje_incumplimiento * pagoalquiler_cant_pagos) / SUM(pagoalquiler_cant_pagos) as 'Porcentaje incumplimiento'
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
    SUM(pagoalquiler_porcentaje_aumento * pagoalquiler_cant_pagos) / SUM(pagoalquiler_cant_pagos)  AS 'Porcentaje promedio de incremento'
FROM
    LOS_BORBOTONES.BI_TH_PagoAlquiler 
GROUP BY
    pagoalquiler_anio_pago,
    pagoalquiler_mes_pago
GO


/*Vista 6: Precio promedio de m2 de la venta de inmuebles según el tipo de inmueble y
la localidad para cada cuatrimestre/año. Se calcula en función de las ventas
concretadas.*/
/*
CREATE VIEW LOS_BORBOTONES.vista_precio_promedio_M2Ventas
AS
SELECT 
    venta_anio_inicio as 'Anio de inicio',
    venta_cuatrimestre_inicio as 'Cuatrimestre de venta',
    tipo_inmueble_detalle AS 'Tipo de inmueble',
    venta_localidad as 'Localidad en donde se vendio',
    SUM(venta_precio_promedio * venta_cantidad_ventas)/SUM(venta_cantidad_ventas) AS 'Precio promedio por venta'
FROM
    LOS_BORBOTONES.BI_TH_Ventas
    JOIN LOS_BORBOTONES.BI_D_TipoInmueble ON venta_tipo_inmueble = tipo_inmueble_codigo
	JOIN LOS_BORBOTONES.BI_D_Tipo_moneda on venta_tipo_moneda = moneda_codigo
GROUP BY
    venta_anio_inicio,
    venta_cuatrimestre_inicio,
    tipo_inmueble_detalle,
    venta_localidad,
    moneda_detalle
GO
*/
/*7. Valor promedio de la comisión según el tipo de operación (alquiler, venta, etc)
y sucursal para cada cuatrimestre/año. Se calcula en función de los alquileres y
ventas concretadas dentro del periodo.*/

CREATE VIEW LOS_BORBOTONES.vista_valor_promedio_comision
AS
SELECT 
   	tipoOperacion_detalle AS 'Tipo Operacion',
    sucursal_detalle AS 'Sucursal',
	anuncio_anio_publicacion AS 'Anio publicacion anuncio',
    anuncio_cuatrimestre_publicacion AS 'Cuatrimestre publicacion anuncio',
    SUM(anuncio_comision_promedio * anuncio_cantidad_anuncios) / SUM(anuncio_cantidad_anuncios) AS 'Valor promedio comision'
FROM LOS_BORBOTONES.BI_TH_Anuncio 
    JOIN LOS_BORBOTONES.BI_D_TipoOperacion ON anuncio_tipoOperacion = tipoOperacion_codigo
    JOIN LOS_BORBOTONES.BI_D_Sucursal ON anuncio_sucursal = sucursal_codigo
GROUP BY
    tipoOperacion_detalle,
    sucursal_detalle,
	anuncio_anio_publicacion,
    anuncio_cuatrimestre_publicacion
GO


/*Vista 8. Porcentaje de operaciones concretadas (tanto de alquileres como ventas) por
-- cada sucursal, según el rango etario de los empleados por año en función de la
-- cantidad de anuncios publicados en ese mismo año.

CREATE VIEW LOS_BORBOTONES.vista_porcentaje_operaciones_concretadas
AS
SELECT 
    t.anio,
    t.cuatrimestre,
    sucursal.nombre AS sucursal,
    rangoEtario.rango_inicio,
    rangoEtario.rango_fin,
    SUM(a.cant_operaciones_concretadas) / SUM(a.cant_anuncios) * 100 AS porcentajeOperacionesConcretadas
FROM
    LOS_BORBOTONES.BI_hecho_anuncio a
    JOIN LOS_BORBOTONES.BI_dim_tiempo t ON a.tiempo = t.id_tiempo
    JOIN LOS_BORBOTONES.BI_dim_sucursal sucursal ON a.sucursal = sucursal.codigo_sucursal
    JOIN LOS_BORBOTONES.BI_dim_rango_etario rangoEtario ON a.rango_etario_agentes = rangoEtario.id_rango_etario
GROUP BY
    t.anio,
    t.cuatrimestre,
    sucursal.nombre,
    rangoEtario.rango_inicio,
    rangoEtario.rango_fin
GO

Vista 9. Monto total de cierre de contratos por tipo de operación (tanto de alquileres
como ventas) por cada cuatrimestre y sucursal, diferenciando el tipo de moneda.

CREATE VIEW LOS_BORBOTONES.BI_Vista_CierreContratos AS
SELECT
    t.anio,
    t.cuatrimestre,
    s.codigo_sucursal,
    tipoOp.nombre as operacion,
    tipoMon.nombre as moneda,
    SUM(a.monto_total_operaciones_concretadas) AS montoTotalCierreContratos
FROM
    LOS_BORBOTONES.BI_hecho_anuncio a
    JOIN LOS_BORBOTONES.BI_D_tipoOperacion  ON a.tipo_operacion = tipoOp.id_tipo_operacion
    JOIN LOS_BORBOTONES.BI_dim_tipo_moneda tipoMon ON a.tipo_moneda = id_tipo_moneda
    JOIN LOS_BORBOTONES.BI_dim_tiempo t ON a.tiempo = t.id_tiempo
    JOIN LOS_BORBOTONES.BI_dim_sucursal s ON a.sucursal = s.codigo_sucursal
WHERE
    a.tiempo IS NOT NULL
GROUP BY
    t.anio,
    t.cuatrimestre,
    s.codigo_sucursal,
    tipoOp.nombre,
    tipoMon.nombre
GO
*/
---------------------------FIN SCRIPT script_creacion_BI---------------------
