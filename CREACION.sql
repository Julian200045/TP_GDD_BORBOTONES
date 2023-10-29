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
    comprador_persona numeric(18,0) NOT NULL,
    comprador_venta numeric(18,0) NOT NULL,
    PRIMARY KEY(comprador_persona,comprador_venta),
    FOREIGN KEY (comprador_persona) REFERENCES Venta(venta_codigo),
    FOREIGN KEY (comprador_venta) REFERENCES Persona(persona_codigo)  
)


CREATE TABLE PagoVenta (
    pagoVenta_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    pagoVenta_venta numeric(18,0) FOREIGN KEY REFERENCES Venta(venta_codigo),
    pagoVenta_moneda numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo),
    pagoVenta_medioDePago numeric(18,0) FOREIGN KEY REFERENCES MedioDePago(medioDePago_codigo),
    pagoVenta_importe numeric(18,2),
    pagoVenta_cotizacion numeric(18,2)
)

