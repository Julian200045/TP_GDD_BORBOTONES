CREATE PROCEDURE creacionDatos
AS

CREATE TABLE Provincia (
    provincia_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    provincia_detalle nvarchar(50)
)

CREATE TABLE Localidad (
    localidad_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    localidad_provincia numeric(18,0) FOREIGN KEY REFERENCES Provincia(provincia_codigo),
    localidad_detalle nvarchar(50)
)

CREATE TABLE Barrio (
    barrio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    barrio_localidad numeric(18,0) FOREIGN KEY REFERENCES Localidad(localidad_codigo),
    barrio_detalle nvarchar(50)
)

CREATE TABLE Sucursal (
    sucursal_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    sucursal_localidad numeric(18,0) FOREIGN KEY REFERENCES Localidad(localidad_codigo),
    sucursal_detalle nvarchar(50),
    sucursal_direccion nvarchar(50),
    sucursal_telefono nvarchar(50)
)

CREATE TABLE TipoInmueble (
    tipo_inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipo_inmueble_detalle nvarchar(100)
)

CREATE TABLE EstadoInmueble (
    estado_inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estado_inmueble_detalle nvarchar(50)
)

CREATE TABLE Ambientes (
    ambientes_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ambientes_detalle nvarchar(50)
)

CREATE TABLE Disposicion (
    disposicion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    disposicion_detalle nvarchar(50)
)

CREATE TABLE Orientacion (
    orientacion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    orientacion_detalle nvarchar(50)
)

CREATE TABLE Caracteristica (
    caracteristica_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    caracteristica_detalle nvarchar(50)
)

CREATE TABLE Inmueble (
	inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    inmueble_tipo numeric(18,0) FOREIGN KEY REFERENCES TipoInmueble(tipo_inmueble_codigo) NOT NULL,
    inmueble_barrio numeric(18,0) FOREIGN KEY REFERENCES Barrio(barrio_codigo),
    inmueble_ambientes numeric(18,0) FOREIGN KEY REFERENCES Ambientes(ambientes_codigo),
    inmueble_orientacion numeric(18,0) FOREIGN KEY REFERENCES Orientacion(orientacion_codigo),
    inmueble_disposicion numeric(18,0) FOREIGN KEY REFERENCES Disposicion(disposicion_codigo),
    inmueble_estado numeric(18,0) FOREIGN KEY REFERENCES EstadoInmueble(estado_inmueble_codigo),
    inmueble_nombre nvarchar(100),
    inmueble_descripcion nvarchar(100),
    inmueble_direccion nvarchar(100),
    inmueble_superficie numeric(10,0),
    inmueble_antiguedad numeric(4,0),
    inmueble_expensas numeric(18,2)
)

CREATE TABLE CaracteristicaPorInmueble (
    caracInmueble_caracteristica numeric(18,0) NOT NULL,
	caracInmueble_inmueble numeric(18,0) NOT NULL,
	PRIMARY KEY(caracInmueble_caracteristica,caracInmueble_inmueble),
	FOREIGN KEY (caracInmueble_caracteristica) REFERENCES Caracteristica(caracteristica_codigo),
    FOREIGN KEY (caracInmueble_inmueble) REFERENCES Inmueble(inmueble_codigo)
)

CREATE TABLE Persona (
    persona_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    persona_nombre nvarchar(50),
    persona_apellido nvarchar(50),
    persona_dni char(8),
    persona_fecha_registro smalldatetime,
    persona_telefono nvarchar(50),
    persona_mail nvarchar(100),
    persona_fecha_nacimiento smalldatetime
)

CREATE TABLE Agente (
    agente_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    agente_persona numeric(18,0) FOREIGN KEY REFERENCES Persona(persona_codigo),
    agente_sucursal numeric(18,0) FOREIGN KEY REFERENCES Sucursal(sucursal_codigo)
)

CREATE TABLE Propietario (
    propietario_persona numeric(18,0) NOT NULL,
    propietario_inmueble numeric(18,0) NOT NULL,
    PRIMARY KEY(propietario_persona,propietario_inmueble),
    FOREIGN KEY (propietario_persona) REFERENCES Persona(persona_codigo),
    FOREIGN KEY (propietario_inmueble) REFERENCES Inmueble(inmueble_codigo)
)

CREATE TABLE Moneda (
    moneda_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    moneda_detalle nvarchar(100)
)

CREATE TABLE MedioDePago (
    medioDePago_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    medioDePago_detalle nvarchar(50)
)

CREATE TABLE TiposPeriodosAnuncio (
    tipoPeriodo_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipoPeriodo_detalle nvarchar(100)
)

CREATE TABLE EstadoAnuncio (
    estadoAnuncio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estadoAnuncio_Detalle nvarchar(100)
)

CREATE TABLE TipoOperacion (
    tipoOperacion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipoOperacion_detalle nvarchar(100)
)

CREATE TABLE Anuncio (
    anuncio_codigo numeric(19,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    anuncio_tipoOperacion numeric(18,0) FOREIGN KEY REFERENCES TipoOperacion(tipoOperacion_codigo),
    anuncio_moneda numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo),
    anuncio_inmueble numeric(18,0) FOREIGN KEY REFERENCES Inmueble(inmueble_codigo),
    anuncio_agente numeric(18,0) FOREIGN KEY REFERENCES Agente(agente_codigo),
    anuncio_estadoAnuncio numeric(18,0) FOREIGN KEY REFERENCES EstadoAnuncio(estadoAnuncio_codigo),
    anuncio_tipoPeriodo numeric(18,0) FOREIGN KEY REFERENCES TiposPeriodosAnuncio(tipoPeriodo_codigo),
    anuncio_fechaPublicacion smalldatetime,
    anuncio_precioPublicado numeric(18,2),
    anuncio_costoAnuncio numeric(18,2),
    anuncio_fechaFinalizacion smalldatetime
)

CREATE TABLE EstadoAlquiler (
    estado_alquiler_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estado_alquiler_detalle nvarchar(50)
)

CREATE TABLE Alquiler (
    alquiler_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    alquiler_anuncio_codigo numeric(19,0) FOREIGN KEY REFERENCES Anuncio(anuncio_codigo),
    alquiler_estado numeric(18,0) FOREIGN KEY REFERENCES EstadoAlquiler(estado_alquiler_codigo),
    alquiler_fecha_inicio smalldatetime,
    alquiler_fecha_fin smalldatetime,
    alquiler_cantidad_periodos numeric(18,0),
    alquiler_deposito numeric(18,0),
    alquiler_comision numeric(18,0),
    alquiler_gastos_averiguaciones numeric(18,2)
)

CREATE TABLE ImportePorPeriodos (
    ip_alquiler_codigo numeric(18,0) NOT NULL,
    ip_nroPeriodoInicio numeric(4,0) NOT NULL,
    ip_nroPeriodoFin numeric(4,0) NOT NULL,
    PRIMARY KEY(ip_alquiler_codigo,ip_nroPeriodoInicio,ip_nroPeriodoFin),
    FOREIGN KEY (ip_alquiler_codigo) REFERENCES Alquiler(alquiler_codigo),
    ip_precio numeric(18,2)
)

CREATE TABLE PagoAlquiler (
    pagoAlquiler_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    pagoAlquiler_alquiler numeric(18,0) FOREIGN KEY REFERENCES Alquiler(alquiler_codigo),
    pagoAlquiler_medioDePago numeric(18,0) FOREIGN KEY REFERENCES MedioDePago(medioDePago_codigo),
    pagoAlquiler_fechaPago smalldatetime,
    pagoAlquiler_nroPeriodo numeric(4,0),
    pagoAlquiler_detallePeriodo nvarchar(100),
    pagoAlquiler_fechaInicioPeriodo smalldatetime,
    pagoAlquiler_fechaFinPeriodo smalldatetime,
    pagoAlquiler_importe numeric(18,2)
)

CREATE TABLE Inquilino (
    inquilino_persona numeric(18,0) NOT NULL,
    inquilino_alquiler numeric(18,0) NOT NULL,
    PRIMARY KEY(inquilino_persona,inquilino_alquiler),
    FOREIGN KEY (inquilino_alquiler) REFERENCES Alquiler(alquiler_codigo),   
    FOREIGN KEY (inquilino_persona) REFERENCES Persona(persona_codigo)    

)

CREATE TABLE Venta (
    venta_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    venta_moneda numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo) NOT NULL,
    venta_anuncio numeric(19,0) FOREIGN KEY REFERENCES Anuncio(anuncio_codigo) NOT NULL,
    venta_fecha smalldatetime,
    venta_comision numeric(18,2),
    venta_precio numeric(18,2)
)

CREATE TABLE Comprador (
    comprador_venta numeric(18,0) NOT NULL,
	comprador_persona numeric(18,0) NOT NULL,
    PRIMARY KEY(comprador_persona,comprador_venta),
    FOREIGN KEY (comprador_persona) REFERENCES Persona(persona_codigo),
    FOREIGN KEY (comprador_venta) REFERENCES Venta(venta_codigo)
)

CREATE TABLE PagoVenta (
    pagoVenta_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    pagoVenta_venta numeric(18,0) FOREIGN KEY REFERENCES Venta(venta_codigo),
    pagoVenta_moneda numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo),
    pagoVenta_medioDePago numeric(18,0) FOREIGN KEY REFERENCES MedioDePago(medioDePago_codigo),
    pagoVenta_importe numeric(18,2),
    pagoVenta_cotizacion numeric(18,2)
)

GO

----------------------------------

CREATE PROCEDURE migracionDatos
AS

--TIPOINMUEBLE
INSERT INTO TipoInmueble (tipo_inmueble_detalle)
SELECT distinct(INMUEBLE_TIPO_INMUEBLE) FROM gd_esquema.Maestra
WHERE INMUEBLE_TIPO_INMUEBLE IS NOT NULL
INSERT INTO TipoInmueble (tipo_inmueble_detalle) 
values ('Casa'),
       ('PH')

--AMBIENTES
INSERT INTO Ambientes (ambientes_detalle)
SELECT distinct(INMUEBLE_CANT_AMBIENTES) FROM gd_esquema.Maestra
WHERE INMUEBLE_CANT_AMBIENTES IS NOT NULL

--ORIENTACION
INSERT INTO Orientacion (orientacion_detalle)
SELECT distinct(INMUEBLE_ORIENTACION)  FROM gd_esquema.Maestra
WHERE INMUEBLE_ORIENTACION IS NOT NULL

--DISPOSICION
INSERT INTO Disposicion (disposicion_detalle)
SELECT distinct(INMUEBLE_DISPOSICION)  FROM gd_esquema.Maestra
WHERE INMUEBLE_DISPOSICION IS NOT NULL

--ESTADOINMUEBLE
INSERT INTO EstadoInmueble (estado_inmueble_detalle)
SELECT distinct(INMUEBLE_ESTADO)  FROM gd_esquema.Maestra
WHERE INMUEBLE_ESTADO IS NOT NULL
INSERT INTO EstadoInmueble (estado_inmueble_detalle) values('Regular')

--TIPOOPERACION
INSERT INTO TipoOperacion (tipoOperacion_detalle)
SELECT distinct(ANUNCIO_TIPO_OPERACION) FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_OPERACION IS NOT NULL

--CARACTERISTICA
INSERT INTO Caracteristica (caracteristica_detalle) 
values ('Calefaccion'),
       ('WIFI'),
       ('Cable'),
       ('Gas'),
       ('Piscina'),
       ('Aire acondicionado'),
       ('Amoblamiento')

--MEDIODEPAGO
INSERT INTO MedioDePago (medioDePago_Detalle)
SELECT distinct(PAGO_ALQUILER_MEDIO_PAGO) FROM gd_esquema.Maestra
WHERE PAGO_ALQUILER_MEDIO_PAGO IS NOT NULL
INSERT INTO MedioDePago (medioDePago_Detalle) 
values ('Crédito'),
       ('Débito')

--MONEDA
INSERT INTO Moneda (moneda_detalle)
SELECT DISTINCT ANUNCIO_MONEDA FROM gd_esquema.Maestra
WHERE ANUNCIO_MONEDA IS NOT NULL

--ESTADOALQUILER
INSERT INTO EstadoAlquiler (estado_alquiler_detalle)
SELECT distinct(ALQUILER_ESTADO) FROM gd_esquema.Maestra
WHERE ALQUILER_ESTADO IS NOT NULL
INSERT INTO EstadoAlquiler (estado_alquiler_detalle) 
values ('Vigente'),
       ('Cancelado')

--TIPOSPERIODOSANUNCIO
INSERT INTO TiposPeriodosAnuncio (tipoPeriodo_detalle)
SELECT distinct ANUNCIO_TIPO_PERIODO FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_PERIODO IS NOT NULL

--ESTADOANUNCIO
INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle)
SELECT distinct(anuncio_estado) FROM gd_esquema.Maestra
WHERE anuncio_estado IS NOT NULL
INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle) values ('Vigente')

--PERSONA
INSERT INTO Persona (persona_dni, persona_nombre, persona_apellido, persona_fecha_registro, persona_telefono, persona_mail, persona_fecha_nacimiento)
SELECT DISTINCT(inquilino_dni), inquilino_nombre, inquilino_apellido, inquilino_fecha_registro, inquilino_telefono, inquilino_mail, inquilino_fecha_nac FROM gd_esquema.Maestra m
WHERE inquilino_dni IS NOT NULL
UNION
SELECT DISTINCT(propietario_dni), propietario_nombre, propietario_apellido, propietario_fecha_registro, propietario_telefono, propietario_mail, propietario_fecha_nac FROM gd_esquema.Maestra
WHERE propietario_dni IS NOT NULL
UNION
SELECT DISTINCT(comprador_dni), comprador_nombre, comprador_apellido,comprador_fecha_registro, comprador_telefono,comprador_mail, comprador_fecha_nac FROM gd_esquema.Maestra
WHERE comprador_dni IS NOT NULL
UNION
SELECT  DISTINCT(agente_dni), agente_nombre, agente_apellido, agente_fecha_registro, agente_telefono, agente_mail, agente_fecha_nac FROM gd_esquema.Maestra
WHERE agente_dni IS NOT NULL

--PROVINCIA
INSERT INTO Provincia (provincia_detalle)
SELECT distinct(INMUEBLE_PROVINCIA) FROM gd_esquema.Maestra
WHERE INMUEBLE_PROVINCIA IS NOT NULL

--LOCALIDAD
INSERT INTO Localidad (localidad_detalle, localidad_provincia)
SELECT distinct(inmueble_localidad), provincia_codigo FROM gd_esquema.Maestra
JOIN Provincia ON inmueble_provincia = provincia_detalle
WHERE inmueble_localidad IS NOT NULL
UNION
SELECT distinct(sucursal_localidad), provincia_codigo FROM gd_esquema.Maestra
JOIN Provincia ON sucursal_provincia = provincia_detalle
WHERE sucursal_localidad IS NOT NULL

--BARRIO
INSERT INTO Barrio (barrio_detalle, barrio_localidad)
SELECT distinct(inmueble_barrio), localidad_codigo FROM gd_esquema.Maestra
JOIN Localidad ON inmueble_localidad = localidad_detalle
WHERE inmueble_barrio IS NOT NULL

--SUCURSAL
SET IDENTITY_INSERT sucursal on
INSERT INTO Sucursal (sucursal_codigo, sucursal_localidad, sucursal_detalle, sucursal_direccion, sucursal_telefono)
SELECT distinct(sucursal_codigo), localidad_codigo, sucursal_nombre, sucursal_direccion, sucursal_telefono FROM gd_esquema.Maestra
JOIN Localidad ON localidad_detalle = sucursal_localidad AND localidad_provincia = (SELECT provincia_codigo FROM Provincia WHERE provincia_detalle = sucursal_provincia)
WHERE sucursal_localidad IS NOT NULL
SET IDENTITY_INSERT sucursal off

--AGENTE
INSERT INTO agente (agente_persona,agente_sucursal)
select distinct(persona_codigo),SUCURSAL_CODIGO from gd_esquema.Maestra
join persona on persona_dni = agente_dni and persona_nombre = agente_nombre

--INMUEBLE
SET IDENTITY_INSERT inmueble on
insert into inmueble (inmueble_codigo,inmueble_tipo, inmueble_barrio, inmueble_ambientes, inmueble_orientacion, inmueble_disposicion, inmueble_estado,
				inmueble_nombre, inmueble_descripcion, inmueble_direccion, inmueble_superficie, inmueble_antiguedad, inmueble_expensas)
select distinct(inmueble_codigo), 
	tipo_inmueble_codigo, 
		barrio_codigo, 
			ambientes_codigo, 
				orientacion_codigo, 
					disposicion_codigo, 
						estado_inmueble_codigo,
				inmueble_nombre, inmueble_descripcion, inmueble_direccion, inmueble_superficietotal, inmueble_antiguedad, inmueble_expesas
from gd_esquema.Maestra
join tipoinmueble on INMUEBLE_TIPO_INMUEBLE = tipo_inmueble_detalle
join barrio on inmueble_barrio = barrio_detalle AND barrio_localidad = (SELECT localidad_codigo FROM Localidad WHERE localidad_detalle = inmueble_localidad AND localidad_provincia = (SELECT provincia_codigo FROM provincia WHERE provincia_detalle = inmueble_provincia))  
join ambientes on ambientes_detalle = inmueble_cant_ambientes
join orientacion on orientacion_detalle = inmueble_orientacion
join disposicion on disposicion_detalle = inmueble_disposicion
join estadoinmueble on estado_inmueble_detalle = inmueble_estado
where inmueble_codigo is not null

SET IDENTITY_INSERT inmueble off

--CARACTERISTICA POR INMUEBLE
insert into caracteristicaporinmueble (caracInmueble_inmueble,caracInmueble_caracteristica)
select distinct(inmueble_codigo),caracteristica_codigo from gd_esquema.MAestra
join Caracteristica on (INMUEBLE_CARACTERISTICA_CABLE = 1 and caracteristica_detalle = 'Cable')
union
select distinct(inmueble_codigo),caracteristica_codigo from gd_esquema.MAestra
join Caracteristica on (INMUEBLE_CARACTERISTICA_CALEFACCION = 1 and caracteristica_detalle = 'Calefaccion')
union
select distinct(inmueble_codigo),caracteristica_codigo from gd_esquema.MAestra
join Caracteristica on (INMUEBLE_CARACTERISTICA_WIFI = 1 and caracteristica_detalle = 'WIFI')
union
select distinct(inmueble_codigo),caracteristica_codigo from gd_esquema.MAestra
join Caracteristica on (INMUEBLE_CARACTERISTICA_GAS = 1 and caracteristica_detalle = 'Gas')

--PROPIETARIO
INSERT INTO Propietario (propietario_persona,propietario_inmueble)
select distinct(p.persona_codigo), m.inmueble_codigo from Persona p 
join gd_esquema.Maestra m on persona_dni = propietario_dni

--ANUNCIO
SET IDENTITY_INSERT Anuncio on 

INSERT INTO Anuncio(anuncio_codigo, anuncio_tipoOperacion,anuncio_moneda,anuncio_inmueble,anuncio_agente,anuncio_estadoAnuncio,anuncio_tipoPeriodo,
anuncio_fechaPublicacion,anuncio_precioPublicado,anuncio_costoAnuncio,anuncio_fechaFinalizacion)
SELECT DISTINCT(anuncio_codigo), tipoOp.tipoOperacion_codigo, moneda.moneda_codigo, INMUEBLE_CODIGO, agente.agente_codigo, ean.estadoAnuncio_codigo,
tipoPe.tipoPeriodo_codigo, ANUNCIO_FECHA_PUBLICACION,ANUNCIO_PRECIO_PUBLICADO, ANUNCIO_COSTO_ANUNCIO, ANUNCIO_FECHA_FINALIZACION
FROM gd_esquema.Maestra maestra
JOIN TipoOperacion tipoOp on tipoOp.tipoOperacion_detalle = maestra.ANUNCIO_TIPO_OPERACION
JOIN Moneda moneda on moneda.moneda_detalle = maestra.ANUNCIO_MONEDA
JOIN Persona p on p.persona_dni = maestra.AGENTE_DNI
JOIN Agente agente on agente.agente_persona = p.persona_codigo
JOIN EstadoAnuncio ean on ean.estadoAnuncio_Detalle = maestra.anuncio_estado
JOIN TiposPeriodosAnuncio tipoPe on tipoPe.tipoPeriodo_detalle = maestra.ANUNCIO_TIPO_PERIODO
where INMUEBLE_CODIGO is not null

SET IDENTITY_INSERT Anuncio off

--ALQUILER 
SET IDENTITY_INSERT alquiler on

INSERT INTO Alquiler (alquiler_codigo, alquiler_anuncio_codigo, alquiler_estado, alquiler_fecha_inicio, alquiler_fecha_fin, 
                      alquiler_cantidad_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averiguaciones)
SELECT distinct(alquiler_codigo), anuncio_codigo, estado_alquiler_codigo, alquiler_fecha_inicio, alquiler_fecha_fin, 
                alquiler_cant_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averigua FROM gd_esquema.Maestra
JOIN EstadoAlquiler ON estado_alquiler_detalle = alquiler_estado

SET IDENTITY_INSERT alquiler off

--PAGO ALQUILER
SET IDENTITY_INSERT pagoAlquiler on

INSERT INTO PagoAlquiler (pagoAlquiler_codigo, pagoAlquiler_alquiler, pagoAlquiler_medioDePago,
                          pagoAlquiler_fechaPago, pagoAlquiler_nroPeriodo, pagoAlquiler_detallePeriodo, pagoAlquiler_fechaInicioPeriodo, pagoAlquiler_fechaFinPeriodo, pagoAlquiler_importe)
SELECT DISTINCT(PAGO_ALQUILER_CODIGO), alquiler_codigo, mp.medioDePago_codigo,
       PAGO_ALQUILER_FECHA, PAGO_ALQUILER_NRO_PERIODO, PAGO_ALQUILER_DESC, PAGO_ALQUILER_FEC_INI, PAGO_ALQUILER_FEC_FIN, PAGO_ALQUILER_IMPORTE
FROM gd_esquema.Maestra maestra
JOIN MedioDePago mp on mp.medioDePago_detalle = maestra.PAGO_ALQUILER_MEDIO_PAGO

SET IDENTITY_INSERT pagoAlquiler off

--VENTA
SET IDENTITY_INSERT venta on

INSERT INTO Venta (venta_codigo, venta_moneda, venta_anuncio, venta_fecha, venta_comision, venta_precio)
SELECT distinct(venta_codigo), moneda_codigo, anuncio_codigo, venta_fecha, venta_comision, venta_precio_venta 
FROM gd_esquema.Maestra
JOIN Moneda ON venta_moneda = moneda_detalle

SET IDENTITY_INSERT venta off

--PAGO VENTA
INSERT INTO PagoVenta (pagoVenta_venta, pagoVenta_moneda, pagoVenta_medioDePago,
                       pagoVenta_importe, pagoVenta_cotizacion)
SELECT VENTA_CODIGO, mo.moneda_codigo, mp.medioDePago_codigo,
       PAGO_VENTA_IMPORTE, PAGO_VENTA_COTIZACION
FROM gd_esquema.Maestra maestra
JOIN Moneda mo on mo.moneda_detalle = maestra.pago_venta_moneda
JOIN MedioDePago mp on mp.medioDePago_detalle = maestra.pago_venta_medio_pago

--INQUILINO
INSERT INTO Inquilino (inquilino_alquiler,inquilino_persona)
select distinct(m.alquiler_codigo),p.persona_codigo 
from Persona p 
join gd_esquema.Maestra m on persona_dni = inquilino_dni 

--COMPRADOR
INSERT INTO Comprador (comprador_venta,comprador_persona)
select distinct venta_codigo ,p.persona_codigo 
from gd_esquema.Maestra maestra
join Persona p on (p.persona_dni = maestra.comprador_dni and p.persona_apellido = maestra.COMPRADOR_apellido)

--IMPORTEPORPERIODOS
insert into ImportePorPeriodos (ip_alquiler_codigo,ip_nroPeriodoInicio,ip_nroPeriodoFin,ip_precio)
select distinct(alquiler_codigo),detalle_alq_nro_periodo_ini,detalle_alq_nro_periodo_fin,detalle_alq_precio from gd_esquema.Maestra
where alquiler_codigo is not null and DETALLE_ALQ_NRO_PERIODO_FIN is not null and DETALLE_ALQ_NRO_PERIODO_INI is not null

GO

exec creacionDatos
exec migracionDatos