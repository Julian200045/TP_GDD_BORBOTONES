SET IDENTITY_INSERT alquiler on
INSERT INTO Alquiler (alquiler_codigo, alquiler_anuncio_codigo, alquiler_estado, alquiler_fecha_inicio, alquiler_fecha_fin, 
                      alquiler_cantidad_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averiguaciones)
SELECT distinct(alquiler_codigo), anuncio_codigo, estado_alquiler_codigo, alquiler_fecha_inicio, alquiler_fecha_fin, 
        alquiler_cantidad_periodos, alquiler_deposito, alquiler_comision, alquiler_gastos_averigua FROM gd_esquema.Maestra
JOIN EstadoAlquiler ON estado_alquiler_detalle = alquiler_estado
SET IDENTITY_INSERT sucursal off