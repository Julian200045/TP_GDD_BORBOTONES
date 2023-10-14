 
insert into ambientes (ambientes_detalle)
select distinct(INMUEBLE_CANT_AMBIENTES)  from gd_esquema.Maestra
where INMUEBLE_CANT_AMBIENTES is not null

insert into orientacion (orientacion_detalle)
select distinct(INMUEBLE_ORIENTACION)  from gd_esquema.Maestra
where INMUEBLE_ORIENTACION is not null

insert into disposicion (disposicion_detalle)
select distinct(INMUEBLE_DISPOSICION)  from gd_esquema.Maestra
where INMUEBLE_DISPOSICION is not null

INSERT INTO INMUEBLE (INMUEBLE_CODIGO, INMUEBLE_DIRECCION, INMUEBLE_AMBIENTES)
SELECT distinct(inmueble_codigo), inmueble_direccion, ambientes_codigo
FROM gd_esquema.maestra 
JOIN ambientes ON inmueble_cant_ambientes = ambientes_detalle;

insert into inmueble (inmueble_direccion) values ('Rivadavia 1000')

SET IDENTITY_INSERT inmueble Off

select * from ambientes
select * from inmueble
select * from gd_esquema.maestra where inmueble_direccion is not null

