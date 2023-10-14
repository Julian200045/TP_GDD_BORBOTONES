CREATE TABLE Provincia (
    provincia_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    provincia_detalle nvarchar(50)
)

CREATE TABLE Localidad (
    localidad_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    provincia_codigo numeric(18,0) FOREIGN KEY REFERENCES Provincia(provincia_codigo),
    localidad_detalle nvarchar(50)
)

CREATE TABLE Barrio (
    barrio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    localidad_codigo numeric(18,0) FOREIGN KEY REFERENCES Localidad(localidad_codigo),
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
    tipo_inmueble_detalle nvarchar(50)
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
    caracteristica_descripcion nvarchar(100)
)

CREATE TABLE Inmueble (
	inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    inmueble_tipo numeric(18,0) FOREIGN KEY REFERENCES TipoInmueble(tipo_inmueble_codigo) NOT NULL,
    inmueble_barrio numeric(18,0) FOREIGN KEY REFERENCES Barrio(barrio_codigo),
    inmueble_ambientes numeric(18,0) FOREIGN KEY REFERENCES Ambientes(ambientes_codigo),
    inmueble_orientacion numeric(18,0) FOREIGN KEY REFERENCES Orientacion(orientacion_codigo),
    inmueble_disposicion numeric(18,0) FOREIGN KEY REFERENCES Disposicion(disposicion_codigo),
    inmueble_estado numeric(18,0) FOREIGN KEY REFERENCES EstadoInmueble(estado_inmueble_codigo),
    inmueble_nombre nvarchar(50),
    inmueble_descripcion nvarchar(100),
    inmueble_direccion nvarchar(50),
    inmueble_superficie numeric(10,0),
    inmueble_antiguedad numeric(4,0),
    inmueble_expensas numeric(18,2)
)

CREATE TABLE CaracteristicaPorInmueble (
    caracteristica_codigo numeric(18,0) FOREIGN KEY REFERENCES Caracteristica(caracteristica_codigo),
    inmueble_codigo numeric(18,0) FOREIGN KEY REFERENCES Inmueble(inmueble_codigo)
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
    persona_codigo numeric(18,0) FOREIGN KEY REFERENCES Persona(persona_codigo),
    sucursal_codigo numeric(18,0) FOREIGN KEY REFERENCES Sucursal(sucursal_codigo)
)

CREATE TABLE Propietario (
    persona_codigo numeric(18,0) NOT NULL,
    inmueble_codigo numeric(18,0) NOT NULL,
    PRIMARY KEY(persona_codigo,inmueble_codigo),
    FOREIGN KEY (persona_codigo) REFERENCES Persona(persona_codigo),
    FOREIGN KEY (inmueble_codigo) REFERENCES Inmueble(inmueble_codigo)
)

CREATE TABLE Moneda (
    moneda_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    moneda_detalle nvarchar(50)
)

CREATE TABLE MedioDePago (
    medioDePago_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    medioDePago_detalle nvarchar(50)
)

CREATE TABLE TiposPeriodosAnuncio (
    tipoPeriodo_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipoPeriodo_detalle nvarchar(50)
)

CREATE TABLE EstadosAnuncio (
    estadoAnuncio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estadoAnuncio_Detalle nvarchar(50)
)

CREATE TABLE TipoOperacion (
    tipoOperacion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipoOperacion_detalle nvarchar(100)
)

CREATE TABLE Anuncio (
    anuncio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipoOperacion_codigo numeric(18,0) FOREIGN KEY REFERENCES TipoOperacion(tipoOperacion_codigo),
    moneda_codigo numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo),
    inmueble_codigo numeric(18,0) FOREIGN KEY REFERENCES Inmueble(inmueble_codigo),
    persona_codigo numeric(18,0) FOREIGN KEY REFERENCES Persona(persona_codigo),
    estadoAnuncio_codigo numeric(18,0) FOREIGN KEY REFERENCES EstadosAnuncio(estadoAnuncio_codigo),
    tipoPeriodo_codigo numeric(18,0) FOREIGN KEY REFERENCES TiposPeriodosAnuncio(tipoPeriodo_codigo),
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
    alquiler_anuncio_codigo numeric(18,0) FOREIGN KEY REFERENCES Anuncio(anuncio_codigo),
    alquiler_estado numeric(18,0) FOREIGN KEY REFERENCES EstadoAlquiler(estado_alquiler_codigo),
    alquiler_fecha_inicio smalldatetime,
    alquiler_fecha_fin smalldatetime,
    alquiler_cantidad_periodos numeric(18,0),
    alquiler_deposito numeric(18,0),
    alquiler_comision numeric(18,0)
)

CREATE TABLE ImporteXPeriodos (
    alquiler_codigo numeric(18,0) NOT NULL,
    importeXPeriodos_nroPeriodoInicio numeric(4,0) NOT NULL,
    importeXPeriodos_nroPeriodoFin numeric(4,0) NOT NULL,
    PRIMARY KEY(alquiler_codigo,importeXPeriodos_nroPeriodoInicio,importeXPeriodos_nroPeriodoFin),
    FOREIGN KEY (alquiler_codigo) REFERENCES Alquiler(alquiler_codigo),
    importeXPeriodos_precio numeric(18,2)
)

CREATE TABLE PagoAlquiler (
    pagoAlquiler_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    alquiler_codigo numeric(18,0) FOREIGN KEY REFERENCES Alquiler(alquiler_codigo),
    medioDePago_codigo numeric(18,0) FOREIGN KEY REFERENCES MedioDePago(medioDePago_codigo),
    pagoAlquiler_fechaPago smalldatetime,
    pagoAlquiler_nroPedido numeric(4,0),
    pagoAlquiler_detallePeriodo nvarchar(100),
    pagoAlquiler_fechaInicioPeriodo smalldatetime,
    pagoAlquiler_fechaFinPeriodo smalldatetime,
    pagoAlquiler_importe numeric(18,2)
)

CREATE TABLE Inquilino (
    persona_codigo numeric(18,0) NOT NULL,
    alquiler_codigo numeric(18,0) NOT NULL,
    PRIMARY KEY(persona_codigo,alquiler_codigo),
    FOREIGN KEY (alquiler_codigo) REFERENCES Alquiler(alquiler_codigo),   
    FOREIGN KEY (persona_codigo) REFERENCES Persona(persona_codigo)    

)

CREATE TABLE Venta (
    venta_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    venta_moneda numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo) NOT NULL,
    venta_anuncio numeric(18,0) FOREIGN KEY REFERENCES Anuncio(anuncio_codigo) NOT NULL,
    venta_feacha smalldatetime,
    venta_comision numeric(18,2),
    venta_precio numeric(18,2)
)

CREATE TABLE Comprador (
    persona_codigo numeric(18,0) NOT NULL,
    venta_codigo numeric(18,0) NOT NULL,
    PRIMARY KEY(persona_codigo,venta_codigo),
    FOREIGN KEY (venta_codigo) REFERENCES Venta(venta_codigo),
    FOREIGN KEY (persona_codigo) REFERENCES Persona(persona_codigo)  
)


CREATE TABLE PagoVenta (
    pagoVenta_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    venta_codigo numeric(18,0) FOREIGN KEY REFERENCES Venta(venta_codigo),
    moneda_codigo numeric(18,0) FOREIGN KEY REFERENCES Moneda(moneda_codigo),
    medioDePago_codigo numeric(18,0) FOREIGN KEY REFERENCES MedioDePago(medioDePago_codigo),
    pagoVenta_importe numeric(18,2),
    pagoVenta_cotizacion numeric(18,2),
    pagoVenta_fecha smalldatetime
)

