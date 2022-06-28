USE master
GO

DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'DB_VENTAS_COMPRAS_STAGE'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQL)
GO

IF EXISTS(select * from sys.databases where name='DB_VENTAS_COMPRAS_STAGE')
DROP DATABASE DB_VENTAS_COMPRAS_STAGE;

Create Database DB_VENTAS_COMPRAS_STAGE;
GO
Use DB_VENTAS_COMPRAS_STAGE

set dateformat YMD

GO

CREATE TABLE stg_ventas_servicios (
	sk_cliente	int,
	sk_empleado int,
	sk_servicio int,
	sk_fecha_venta int,
	sk_complejidad int,
	sk_fecha_pago int,
	sk_metodo_estado int,
	cod_venta int,
	monto_venta decimal (10,2),
	duracion_pago int
)

CREATE TABLE stg_ventas_productos (
	sk_cliente	int,
	sk_empleado int,
	sk_producto int,
	sk_fecha_venta int,
	sk_fecha_pago int,
	sk_metodo_estado int,
	cod_venta int,
	costo_venta decimal (10,2),
	monto_venta decimal (10,2),
	cantindad_venta int,
	margen_ganancia decimal (10,2),
	duracion_pago int
)

CREATE TABLE stg_compras (
	sk_proveedor	int,
	sk_empleado int,
	sk_producto int,
	sk_fecha_compra int,
	sk_fecha_pago int,
	sk_metodo_estado int,
	cod_compra int,
	cantindad_pedido int,
	monto_compra decimal (10,2),
)

CREATE TABLE stg_proveedor (
	sk_proveedor int identity(5000,1) primary key,
	razon_social nvarchar(50),
	cod_proveedor int,
	ruc nvarchar(50),
	tipo_proveedor nvarchar(50)
)

create table stg_fechas (
    sk_fecha int not null primary key,
	fecha date not null, 
	anio smallint not null,
	semestre nvarchar(30),
	trimestre nvarchar(30),
	mes nvarchar(30),
	dia_semana nvarchar(30),
	num_semestre_anio smallint,
	num_trimestre_anio smallint,
	num_mes_anio smallint,
	num_dia_semana smallint,
	num_dia_mes smallint,
	num_semana_anio smallint
)

create table stg_categoria (
	sk_categoria int identity (5000,1) primary key,
	cod_categoria int,
	categoria nvarchar(50) not null
);

create table stg_producto (
	sk_producto int identity (5000,1) primary key,
	cod_producto int not null,
	sk_categoria int not null,
	producto nvarchar(50) not null,
	precio_unitario decimal(10,2) not null,
	costo_unitario decimal (10,2) not null
);

create table stg_servicio (
	sk_servicio int identity (5000,1) primary key,
	cod_servicio int,
	nombre nvarchar(50) not null,
	categoria_servicio nvarchar(50) not null,
	precio_base decimal(10,2) not null
);

create table stg_complejidad (
	sk_complejidad int identity (5000,1) primary key,
	cod_complejidad int,
	nombre nvarchar(50) not null,
	factor decimal (3,2) not null
);

create table stg_junk_metodo_estado(
	sk_metodo_estado int identity (5000,1) primary key,
	metodo_pago nvarchar(50) not null,
	estado_pago nvarchar(50) not null
);

create table stg_persona(
	sk_persona int identity (5000,1) primary key,
	cod_persona int not null,
	nombre_completo nvarchar(101) not null,
	identificacion nvarchar(50) not null
	--tipo_persona varchar(50) not null
)
GO
