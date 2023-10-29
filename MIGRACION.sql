--Tablas sin FK
CREATE PROCEDURE migracionDatos
AS

INSERT INTO TipoInmueble (tipo_inmueble_detalle)
SELECT distinct(INMUEBLE_TIPO_INMUEBLE) FROM gd_esquema.Maestra
WHERE INMUEBLE_TIPO_INMUEBLE IS NOT NULL
INSERT INTO TipoInmueble (tipo_inmueble_detalle) 
values ('Casa'),
       ('PH')

INSERT INTO Ambientes (ambientes_detalle)
SELECT distinct(INMUEBLE_CANT_AMBIENTES) FROM gd_esquema.Maestra
WHERE INMUEBLE_CANT_AMBIENTES IS NOT NULL

INSERT INTO Orientacion (orientacion_detalle)
SELECT distinct(INMUEBLE_ORIENTACION)  FROM gd_esquema.Maestra
WHERE INMUEBLE_ORIENTACION IS NOT NULL

INSERT INTO Disposicion (disposicion_detalle)
SELECT distinct(INMUEBLE_DISPOSICION)  FROM gd_esquema.Maestra
WHERE INMUEBLE_DISPOSICION IS NOT NULL

INSERT INTO EstadoInmueble (estado_inmueble_detalle)
SELECT distinct(INMUEBLE_ESTADO)  FROM gd_esquema.Maestra
WHERE INMUEBLE_ESTADO IS NOT NULL
INSERT INTO EstadoInmueble (estado_inmueble_detalle) values('Regular')

INSERT INTO TipoOperacion (tipoOperacion_detalle)
SELECT distinct(ANUNCIO_TIPO_OPERACION) FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_OPERACION IS NOT NULL

INSERT INTO Caracteristica (caracteristica_detalle) 
values ('Calefacción central'),
       ('WIFI'),
       ('Cable'),
       ('Gas'),
       ('Piscina'),
       ('Aire acondicionado'),
       ('Amoblamiento')

INSERT INTO MedioDePago (medioDePago_Detalle)
SELECT distinct(PAGO_ALQUILER_MEDIO_PAGO) FROM gd_esquema.Maestra
WHERE PAGO_ALQUILER_MEDIO_PAGO IS NOT NULL
INSERT INTO MedioDePago (medioDePago_Detalle) 
values ('Crédito'),
       ('Débito')

/*INSERT INTO Moneda (moneda_detalle)
SELECT DISTINCT
  CASE 
    WHEN ANUNCIO_MONEDA = 'Moneda Pesos' THEN 'ARS'
    WHEN ANUNCIO_MONEDA = 'Moneda Dolares' THEN 'USD'
    ELSE 'OTHER'
  END
FROM gd_esquema.Maestra
WHERE ANUNCIO_MONEDA IS NOT NULL
*/

INSERT INTO Moneda (moneda_detalle)
SELECT DISTINCT ANUNCIO_MONEDA FROM gd_esquema.Maestra
WHERE ANUNCIO_MONEDA IS NOT NULL

INSERT INTO EstadoAlquiler (estado_alquiler_detalle)
SELECT distinct(ALQUILER_ESTADO) FROM gd_esquema.Maestra
WHERE ALQUILER_ESTADO IS NOT NULL
INSERT INTO EstadoAlquiler (estado_alquiler_detalle) 
values ('Vigente'),
       ('Cancelado')

/*INSERT INTO TiposPeriodosAnuncio (tipoPeriodo_detalle)
SELECT distinct
    CASE 
    WHEN ANUNCIO_TIPO_PERIODO = '0' THEN 'Sin Periodo'
	WHEN ANUNCIO_TIPO_PERIODO = 'Periodo dia' THEN 'Día'
    ELSE substring(ANUNCIO_TIPO_PERIODO,9,len(ANUNCIO_TIPO_PERIODO)) 
    END
FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_PERIODO IS NOT NULL */

INSERT INTO TiposPeriodosAnuncio (tipoPeriodo_detalle)
SELECT distinct ANUNCIO_TIPO_PERIODO FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_PERIODO IS NOT NULL

INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle)
SELECT distinct(anuncio_estado) FROM gd_esquema.Maestra
WHERE anuncio_estado IS NOT NULL
INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle) values ('Vigente')


INSERT INTO Persona (persona_dni, persona_nombre, persona_apellido, persona_fecha_registro, persona_telefono, persona_mail, persona_fecha_nacimiento)
SELECT inquilino_dni, inquilino_nombre, inquilino_apellido, inquilino_fecha_registro, inquilino_telefono, inquilino_mail, inquilino_fecha_nac FROM gd_esquema.Maestra
WHERE inquilino_dni IS NOT NULL
UNION
SELECT propietario_dni, propietario_nombre, propietario_apellido, propietario_fecha_registro, propietario_telefono, propietario_mail, propietario_fecha_nac FROM gd_esquema.Maestra
WHERE propietario_dni IS NOT NULL
UNION
SELECT comprador_dni, comprador_nombre, comprador_apellido,comprador_fecha_registro, comprador_telefono,comprador_mail, comprador_fecha_nac FROM gd_esquema.Maestra
WHERE comprador_dni IS NOT NULL
UNION
SELECT agente_dni, agente_nombre, agente_apellido, agente_fecha_registro, agente_telefono, agente_mail, agente_fecha_nac FROM gd_esquema.Maestra
WHERE agente_dni IS NOT NULL
------------------------------------------------------------------------------
-- agente inmueble anuncio alquiler pagoAlquiler caracteristicaxinmueble importexperiodos propietarios venta pagoventa inquilino comprador
--Pago Alquiler  

--PROVINCIA
INSERT INTO Provincia (provincia_detalle)
SELECT distinct(INMUEBLE_PROVINCIA) FROM gd_esquema.Maestra
WHERE INMUEBLE_PROVINCIA IS NOT NULL

--LOCALIDAD
INSERT INTO Localidad (localidad_detalle, provincia_codigo)
SELECT distinct(inmueble_localidad), provincia_codigo FROM gd_esquema.Maestra
JOIN Provincia ON inmueble_provincia = provincia_detalle
WHERE inmueble_localidad IS NOT NULL
UNION
SELECT distinct(sucursal_localidad), provincia_codigo FROM gd_esquema.Maestra
JOIN Provincia ON sucursal_provincia = provincia_detalle
WHERE sucursal_localidad IS NOT NULL

--BARRIO
INSERT INTO Barrio (barrio_detalle, localidad_codigo)
SELECT distinct(inmueble_barrio), localidad_codigo FROM gd_esquema.Maestra
JOIN Localidad ON inmueble_localidad = localidad_detalle
WHERE inmueble_barrio IS NOT NULL

--SUCURSAL
SET IDENTITY_INSERT sucursal on
INSERT INTO Sucursal (sucursal_codigo, sucursal_localidad, sucursal_detalle, sucursal_direccion, sucursal_telefono)
SELECT distinct(sucursal_codigo), localidad_codigo, sucursal_nombre, sucursal_direccion, sucursal_telefono FROM gd_esquema.Maestra
JOIN Localidad ON localidad_detalle = sucursal_localidad AND provincia_codigo = (SELECT provincia_codigo FROM Provincia WHERE provincia_detalle = sucursal_provincia)
WHERE sucursal_localidad IS NOT NULL
SET IDENTITY_INSERT sucursal off

--AGENTE
INSERT INTO agente (persona_codigo,sucursal_codigo)
select distinct(persona_codigo),SUCURSAL_CODIGO from gd_esquema.Maestra
join persona on persona_dni = agente_dni and persona_nombre = agente_nombre

--ALQUILER FALTA ANUNCIO ????????
--SET IDENTITY_INSERT alquiler on
--INSERT INTO Alquiler (alquiler_codigo, alquiler_anuncio_codigo, alquiler_estado, alquiler_fecha_inicio, alquiler_fecha_fin, 
  --                    alquiler_cantidad_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averiguaciones)
--SELECT distinct(alquiler_codigo), anuncio_codigo, estado_alquiler_codigo, alquiler_fecha_inicio, alquiler_fecha_fin, 
 --       alquiler_cant_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averigua FROM gd_esquema.Maestra
--JOIN EstadoAlquiler ON estado_alquiler_detalle = alquiler_estado
--SET IDENTITY_INSERT alquiler off

--INQUILINO
-- No se puede hacer porque falta que alquiler sea primary key en otra tabla
/*INSERT INTO Inquilino (persona_codigo,alquiler_codigo)
select distinct(p.persona_codigo), m.alquiler_codigo from Persona p 
join gd_esquema.Maestra m on persona_dni = inquilino_dni */


--COMPRADOR
-- No se puede hacer porque falta que comprador sea primary key en otra tabla
/*INSERT INTO Comprador (persona_codigo,venta_codigo)
select p.persona_codigo, m.venta_codigo from Persona p 
join gd_esquema.Maestra m on persona_dni = comprador_dni*/



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
join barrio on inmueble_barrio = barrio_detalle AND localidad_codigo = (SELECT localidad_codigo FROM Localidad WHERE localidad_detalle = inmueble_localidad AND provincia_codigo = (SELECT provincia_codigo FROM provincia WHERE provincia_detalle = inmueble_provincia))  
join ambientes on ambientes_detalle = inmueble_cant_ambientes
join orientacion on orientacion_detalle = inmueble_orientacion
join disposicion on disposicion_detalle = inmueble_disposicion
join estadoinmueble on estado_inmueble_detalle = inmueble_estado
where inmueble_codigo is not null

SET IDENTITY_INSERT inmueble off


--PROPIETARIO
INSERT INTO Propietario (persona_codigo,inmueble_codigo)
select distinct(p.persona_codigo), m.inmueble_codigo from Persona p 
join gd_esquema.Maestra m on persona_dni = propietario_dni


--ANUNCIO
SET IDENTITY_INSERT Anuncio on 

INSERT INTO Anuncio(anuncio_codigo, anuncio_tipoOperacion,anuncio_moneda,anuncio_inmueble,anuncio_agente,anuncio_estadoAnuncio,anuncio_tipoPeriodo,anuncio_fechaPublicacion,anuncio_precioPublicado,anuncio_costoAnuncio,anuncio_fechaFinalizacion)
SELECT DISTINCT(anuncio_codigo), tipoOp.tipoOperacion_codigo, moneda.moneda_codigo, INMUEBLE_CODIGO, agente.agente_codigo, ean.estadoAnuncio_codigo, tipoPe.tipoPeriodo_codigo, ANUNCIO_FECHA_PUBLICACION,ANUNCIO_PRECIO_PUBLICADO, ANUNCIO_COSTO_ANUNCIO, ANUNCIO_FECHA_FINALIZACION
FROM gd_esquema.Maestra maestra
JOIN TipoOperacion tipoOp on tipoOp.tipoOperacion_detalle = maestra.ANUNCIO_TIPO_OPERACION
JOIN Moneda moneda on moneda.moneda_detalle = maestra.ANUNCIO_MONEDA
JOIN Persona p on p.persona_dni = maestra.AGENTE_DNI
JOIN Agente agente on agente.persona_codigo = p.persona_codigo
JOIN EstadoAnuncio ean on ean.estadoAnuncio_Detalle = maestra.anuncio_estado
JOIN TiposPeriodosAnuncio tipoPe on tipoPe.tipoPeriodo_detalle = maestra.ANUNCIO_TIPO_PERIODO
where INMUEBLE_CODIGO is not null

SET IDENTITY_INSERT Anuncio off


--alamitad

GO