 
INSERT INTO Orientacion (orientacion_detalle)
select distinct(inmueble_orientacion) from gd_esquema.Maestra
Go;