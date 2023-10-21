--Tablas sin FK
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
SELECT distinct(substring(INMUEBLE_DISPOSICION,12,len(INMUEBLE_DISPOSICION)))  FROM gd_esquema.Maestra
WHERE INMUEBLE_DISPOSICION IS NOT NULL

INSERT INTO EstadoInmueble (estado_inmueble_detalle)
SELECT distinct(INMUEBLE_ESTADO)  FROM gd_esquema.Maestra
WHERE INMUEBLE_ESTADO IS NOT NULL
INSERT INTO EstadoInmueble (estado_inmueble_detalle) values('Regular')

INSERT INTO TipoOperacion (tipoOperacion_detalle)
SELECT distinct(substring(ANUNCIO_TIPO_OPERACION,16,len(ANUNCIO_TIPO_OPERACION))) FROM gd_esquema.Maestra
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

INSERT INTO Moneda (moneda_detalle)
SELECT DISTINCT
  CASE 
    WHEN ANUNCIO_MONEDA = 'Moneda Pesos' THEN 'ARS'
    WHEN ANUNCIO_MONEDA = 'Moneda Dolares' THEN 'USD'
    ELSE 'OTHER'
  END
FROM gd_esquema.Maestra
WHERE ANUNCIO_MONEDA IS NOT NULL

INSERT INTO EstadoAlquiler (estadoAlquiler_detalle)
SELECT distinct(ALQUILER_ESTADO) FROM gd_esquema.Maestra
WHERE ALQUILER_ESTADO IS NOT NULL
INSERT INTO EstadoAlquiler (estadoAlquiler_detalle) 
values ('Vigente'),
       ('Cancelado')

INSERT INTO TiposPeriodosAnuncio (tipoPeriodo_detalle)
SELECT distinct
    CASE 
    WHEN ANUNCIO_TIPO_PERIODO = '0' THEN 'Sin Periodo'
	WHEN ANUNCIO_TIPO_PERIODO = 'Periodo dia' THEN 'Día'
    ELSE substring(ANUNCIO_TIPO_PERIODO,9,len(ANUNCIO_TIPO_PERIODO))
    END
FROM gd_esquema.Maestra
WHERE ANUNCIO_TIPO_PERIODO IS NOT NULL

INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle)
SELECT distinct(anuncio_estado) FROM gd_esquema.Maestra
WHERE anuncio_estado IS NOT NULL
INSERT INTO EstadoAnuncio (estadoAnuncio_Detalle) values ('Vigente')

INSERT INTO Persona (persona_dni, persona_nombre, persona_apellido, persona_fecha_registro, persona_telefono, persona_mail, persona_fecha_nacimiento)
SELECT distinct(inquilino_dni), inquilino_nombre, inquilino_apellido, inquilino_fecha_registro, inquilino_telefono, inquilino_mail, inquilino_fecha_nac FROM gd_esquema.Maestra
WHERE inquilino_dni IS NOT NULL
UNION
SELECT distinct(propietario_dni), propietario_nombre, propietario_apellido, propietario_fecha_registro, propietario_telefono, propietario_mail, propietario_fecha_nac FROM gd_esquema.Maestra
WHERE propietario_dni IS NOT NULL
UNION
SELECT distinct(comprador_dni), comprador_nombre, comprador_apellido,comprador_fecha_registro, comprador_telefono,comprador_mail, comprador_fecha_nac FROM gd_esquema.Maestra
WHERE comprador_dni IS NOT NULL
UNION
SELECT distinct(agente_dni), agente_nombre, agente_apellido, agente_fecha_registro, agente_telefono, agente_mail, agente_fecha_nac FROM gd_esquema.Maestra
WHERE agente_dni IS NOT NULL
------------------------------------------------------------------------------
--sucursal agente inmueble anuncio alquiler pagoAlquiler caracteristicaxinmueble importexperiodos propietarios venta pagoventa inquilino comprador

--SUCURSAL
--INSERT INTO sucursal(sucursal_codigo, sucursal_detalle, sucursal_localidad,sucursal_direccion,sucursal_telefono)

--Provincia
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

/*
SET IDENTITY_INSERT inmueble Off
INSERT INTO INMUEBLE (inmueble_codigo, inmueble_direccion, inmueble_ambientes)
SELECT distinct(inmueble_codigo), inmueble_direccion, ambientes_codigo
FROM gd_esquema.maestra 
JOIN ambientes ON inmueble_cant_ambientes = ambientes_detalle;
INSERT INTO inmueble (inmueble_direccion) values ('Rivadavia 1000')
*/
