CREATE TABLE TipoInmueble (
    tipo_inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    tipo_inmuebe_detalle nvarchar(50)
)

CREATE TABLE Barrio (
    barrio_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    barrio_detalle nvarchar(50)
)

CREATE TABLE Ambientes (
    ambientes_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ambientes_detalle nvarchar(50)
)

CREATE TABLE Orientacion (
    orientacion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    orientacion_detalle nvarchar(50)
)

CREATE TABLE Disposicion (
    disposicion_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    disposicion_detalle nvarchar(50)
)

CREATE TABLE EstadoInmueble (
    estado_inmueble_codigo numeric(18,0) IDENTITY(1,1) PRIMARY KEY NOT NULL,
    estado_inmueble_detalle nvarchar(50)
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
