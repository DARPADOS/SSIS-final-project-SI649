USE master
GO

DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'DB_VENTAS_COMPRAS_MART'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQL)
GO

IF EXISTS(select * from sys.databases where name='DB_VENTAS_COMPRAS_MART')
DROP DATABASE DB_VENTAS_COMPRAS_MART;

Create Database DB_VENTAS_COMPRAS_MART;
GO
Use DB_VENTAS_COMPRAS_MART

set dateformat YMD

GO

CREATE TABLE fact_ventas_servicios (
	sk_cliente	int,
	sk_empleado int,
	sk_servicio int,
	sk_fecha_venta int,
	sk_complejidad int,
	sk_fecha_pago int,
	sk_metodo_estado int,
	cod_venta int,
	monto_venta decimal (10,2),
	duracion_pago int,

	primary key (sk_cliente, sk_empleado, sk_servicio, sk_fecha_venta, sk_complejidad, sk_fecha_pago, sk_metodo_estado, cod_venta)
)

CREATE TABLE fact_ventas_productos (
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

	primary key (sk_cliente, sk_empleado, sk_producto, sk_fecha_venta, sk_fecha_pago, sk_metodo_estado, cod_venta)
)

CREATE TABLE fact_compras (
	sk_proveedor	int,
	sk_empleado int,
	sk_producto int,
	sk_fecha_compra int,
	sk_fecha_pago int,
	sk_metodo_estado int,
	cod_compra int,
	cantindad_pedido int,
	monto_compra decimal (10,2),

	primary key (sk_proveedor, sk_empleado, sk_producto, sk_fecha_compra, sk_fecha_pago, sk_metodo_estado, cod_compra)
)

CREATE TABLE dim_proveedor (
	sk_proveedor int primary key,
	razon_social nvarchar(50),
	ruc nvarchar(50),
	tipo_proveedor nvarchar(50)
)

create table dim_fechas (
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

create table dim_categoria (
	sk_categoria int primary key,
	categoria nvarchar(50) not null,
);

create table dim_producto (
	sk_producto int primary key,
	cod_producto int not null,
	sk_categoria int not null,
	producto nvarchar(50) not null,
	precio_unitario decimal(10,2) not null,
	costo_unitario decimal (10,2) not null
);

create table dim_servicio (
	sk_servicio int primary key,	
	nombre nvarchar(50) not null,
	categoria_servicio nvarchar(50) not null,
	precio_base decimal(10,2) not null
);

create table dim_complejidad (
	sk_complejidad int primary key,
	nombre nvarchar(50) not null,
	factor decimal (3,2) not null
);

create table junk_metodo_estado(
	sk_metodo_estado int primary key,
	metodo_pago nvarchar(50) not null,
	estado_pago nvarchar(50) not null
);

create table dim_persona(
	sk_persona int primary key,
	cod_persona int not null,
	nombre_completo nvarchar(101) not null,
	identificacion nvarchar(50) not null,
);

CREATE TABLE fact_margen_ventas_productos (
	sk_fecha int not null,
	anio smallint not null,
	num_mes_anio smallint not null,
	margen decimal (10,2) not null,
	primary key(sk_fecha, anio, num_mes_anio)
)

CREATE TABLE fact_monto_ventas_servicios (
	sk_fecha int not null,
	anio smallint not null,
	num_mes_anio smallint not null,
	monto decimal (10,2),
	primary key (sk_fecha, anio, num_mes_anio)
)
GO