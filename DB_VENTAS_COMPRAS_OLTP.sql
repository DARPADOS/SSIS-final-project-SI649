
USE master
GO

DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'DB_VENTAS_COMPRAS_OLTP'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQL)
GO

IF EXISTS(select * from sys.databases where name='DB_VENTAS_COMPRAS_OLTP')
DROP DATABASE DB_VENTAS_COMPRAS_OLTP;

CREATE DATABASE DB_VENTAS_COMPRAS_OLTP;
GO

USE DB_VENTAS_COMPRAS_OLTP;
GO

create table categoria (
	id int identity (10000,1) primary key,
	categoria nvarchar(50) not null,
);

create table producto (
	id int identity (10000,1) primary key,
	id_categoria int not null,
	producto nvarchar(50) not null,
	precio_unitario decimal(10,2) not null,
	costo decimal (10,2) not null,
	stock int not null,
	foreign key (id_categoria) references categoria(id)
);

create table servicio (
	id int identity (10000,1) primary key,
	nombre nvarchar(50) not null,
	categoria_servicio nvarchar(50) not null,
	precio_base decimal(10,2) not null
);

create table complejidad (
	id int identity (10000,1) primary key,
	nombre nvarchar(50) not null,
	factor decimal (3,2) not null
);

CREATE TABLE proveedor (
	id int NOT NULL identity(10001,1) primary key,
	razon_social nvarchar(50) not null,
	ruc	nvarchar(11) not null,
	tipo_proveedor nvarchar(15) not null,
)

CREATE TABLE persona (
	id int NOT NULL identity(10001,1) primary key,
	nombre nvarchar(50) not null,
	apellido nvarchar(50) not null,
	dni	nvarchar(11) not null,
	telefono nvarchar(15) not null,
	email nvarchar(100) not null
)

CREATE TABLE empleado (
	id int not null primary key,
	fecha_contratacion date not null

	foreign key (id) references persona(id)
)

CREATE TABLE cliente (
	id int not null primary key,
	empresa nvarchar(50) not null

	foreign key (id) references persona(id)
)

CREATE TABLE orden_compra (
	id int NOT NULL identity(10001,1) primary key,
	id_empleado int not null,
	id_proveedor int not null,
	fecha_compra date not null

	foreign key (id_empleado) references empleado(id),
	foreign key (id_proveedor) references proveedor(id) 
)

CREATE TABLE metodo_pago (
	id int NOT NULL identity(10001,1) primary key,
	nombre nvarchar(50) not null
)

CREATE TABLE comprobante_compra (
	id int NOT NULL identity(10001,1) primary key,
	id_pedido int not null,
	id_metodo_pago int not null,
	tipo_comprobante nvarchar(50) not null,
	fecha_pago date not null,

	foreign key (id_metodo_pago) references metodo_pago(id),
	foreign key (id_pedido) references orden_compra(id)                                                        
)

CREATE TABLE detalle_compra_producto (
	id_pedido int not null,
	id_producto int not null,
	cantidad int not null,

	primary key (id_pedido, id_producto),

	/*foreign key (id_producto) references producto(id),*/
	foreign key (id_pedido) references orden_compra(id)     
)

create table orden_venta(
	id int identity (10000,1) primary key,
	id_empleado int not null,
	id_cliente int not null,
	/*pago nvarchar(50) not null,*/
	estado nvarchar(50) not null,
	fecha_venta date not null,
	fecha_pago date not null

	foreign key (id_empleado) references empleado(id),
	foreign key (id_cliente) references cliente(id)
);

create table detalle_venta_producto(
	id_orden_venta int not null,
	id_producto int not null,
	cantidad int not null,

	primary key (id_orden_venta, id_producto),

	foreign key (id_orden_venta) references orden_venta (id),
	foreign key (id_producto) references producto (id)
);

create table detalle_venta_servicio(
	id_servicio int not null,
	id_orden_venta int not null,
	id_complejidad int not null,
	categoria_servicio nvarchar(50)

	primary key (id_orden_venta, id_servicio),

	foreign key (id_orden_venta) references orden_venta (id),
	foreign key (id_complejidad) references complejidad (id),
	foreign key (id_servicio) references servicio (id)
);

create table comprobante_venta(
	id int identity(10000,1) primary key,
	id_metodo_pago int not null,
	id_orden_venta int not null,
	tipo_comprobante nvarchar(50) not null,
	metodo_pago nvarchar(50) not null,

	foreign key (id_metodo_pago) references metodo_pago(id),
	foreign key (id_orden_venta) references orden_venta(id)
);

GO

/* DATOS DE PRUEBA */

/* PROVEEDOR */
INSERT INTO proveedor (razon_social, ruc, tipo_proveedor) VALUES ('DELTRON', '53214781495', 'mayorista')
INSERT INTO proveedor (razon_social, ruc, tipo_proveedor) VALUES ('CISCO', '35397497693', 'fabricante')
INSERT INTO proveedor (razon_social, ruc, tipo_proveedor) VALUES ('HUAWEI', '92720130639', 'fabricante')
INSERT INTO proveedor (razon_social, ruc, tipo_proveedor) VALUES ('RESS WHOLESALE HARDWARE', '54679935224', 'mayorista')
INSERT INTO proveedor (razon_social, ruc, tipo_proveedor) VALUES ('PCLINK', '41550422477', 'mayorista')

GO

/* PERSONA */

INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Tate Kristen','ﾑez Hidalgo','25007810','+51 966035763','nec.quam@protonmail.net');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Moses Cody','Vega Gil','22056572','+51 926315857','tellus@outlook.net');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Oprah Lillian','Nieto Lopez','56616884','+51 976564632','pharetra.ut@yahoo.com');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Amanda Tamara','Muﾑoz Soler','94720428','+51 975231241','quis.pede@outlook.net');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Nichole Sigourney','Romero Gutierrez','57423568','+51 914628119','dui.nec@protonmail.couk');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Leroy Amir','Moreno Gil','60285163','+51 964606809','maecenas@hotmail.couk');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Xander Brody','Redondo Martinez','36368971','+51 932853668','massa@protonmail.edu');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Kay Amethyst','Garrido Gonzalez','47028632','+51 924299157','magna.et.ipsum@yahoo.edu');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Serena Chancellor','Suarez Marquez','30974124','+51 987549894','nulla.eu.neque@protonmail.net');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Jesse Cole','Vicente Redondo','21945426','+51 933030702','enim.suspendisse@protonmail.org');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Bell Jacob','Gallego Moreno','23461580','+51 986735481','justo@outlook.com');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Drake Caleb','Soto Saez','25134270','+51 993144236','duis.a@aol.net');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Sage Octavia','Martinez Saez','16128548','+51 921678123','vitae.orci@aol.edu');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Randall Simone','Blanco Ramos','10955877','+51 952385247','cras.lorem@outlook.edu');
INSERT INTO persona (nombre,apellido,dni,telefono,email) VALUES ('Kerry Sonya','Gallego Hidalgo','59481023','+51 969913850','quam.curabitur.vel@google.edu');

GO

/* EMPLEADO */

INSERT INTO empleado (id, fecha_contratacion) VALUES (10001, CAST(N'2018-09-29' AS Date));
INSERT INTO empleado (id, fecha_contratacion) VALUES (10002, CAST(N'2018-02-05' AS Date));
INSERT INTO empleado (id, fecha_contratacion) VALUES (10003, CAST(N'2018-04-23' AS Date));
INSERT INTO empleado (id, fecha_contratacion) VALUES (10004, CAST(N'2018-06-21' AS Date));
INSERT INTO empleado (id, fecha_contratacion) VALUES (10005, CAST(N'2018-01-15' AS Date));

GO

/* CLIENTE */

INSERT INTO cliente (id, empresa) VALUES (10006, 'Metro');
INSERT INTO cliente (id, empresa) VALUES (10007, 'Tambo');
INSERT INTO cliente (id, empresa) VALUES (10008, 'Restaurant 7 sopas');
INSERT INTO cliente (id, empresa) VALUES (10009, 'Norkys');
INSERT INTO cliente (id, empresa) VALUES (10010, 'Plaza Vea');
INSERT INTO cliente (id, empresa) VALUES (10011, 'Macro');
INSERT INTO cliente (id, empresa) VALUES (10012, 'Claro');
INSERT INTO cliente (id, empresa) VALUES (10013, 'Entel');
INSERT INTO cliente (id, empresa) VALUES (10014, 'Popeyes');
INSERT INTO cliente (id, empresa) VALUES (10015, 'Pizza Raul');

GO

/* METODO_PAGO */

INSERT INTO metodo_pago (nombre) VALUES ('Pago en Efectivo');
INSERT INTO metodo_pago (nombre) VALUES ('Tarjeta de crédito o debito');

GO

/* CATEGORIA */
insert into categoria (categoria) values ('RF & microwave')
insert into categoria (categoria) values ('Microcontrollers (MCUs) & processors')
insert into categoria (categoria) values ('Data converters')
insert into categoria (categoria) values ('Amplifiers')
insert into categoria (categoria) values ('Wireless connectivity')
GO

/* PRODUCTO */
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10000, 'C2000™ 32-bit MCU 120-MHz',19.95,15.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10000, 'Automotive dual-core Arm',75,50,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10001, 'Dual Arm® Cortex-A72',35.6,30,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10001, 'Octal-channel RF transceiver',5.95,2.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10002, 'Two-transmit two-receive, 5-MHz',9.7,5.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10002, 'Six-channel 5-MHz to 12-GHz',63.2,55.5,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10003, 'Automotive dual-channe',19.95,15.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10003, 'Single-channel, 9-bit,',4.95,2.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10004, 'Quad, 40-V',11.95,5.95,100)
insert into producto (id_categoria,producto,precio_unitario,costo,stock) values (10004, 'Low distortion',22.95,15.95,100)
GO

/* SERVICIO */
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio1', 'Categoria1', 500.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio2', 'Categoria1', 400.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio3', 'Categoria2', 300.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio4', 'Categoria2', 550.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio5', 'Categoria3', 650.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio6', 'Categoria3', 1005.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio7', 'Categoria4', 2300.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio8', 'Categoria4', 220.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio9', 'Categoria5', 150.50)
insert into servicio (nombre, categoria_servicio, precio_base) values ('Servicio10', 'Categoria5', 440.50)
GO

/* COMPLEJIDAD */
insert into complejidad (nombre, factor) values ('simple',1.0)
insert into complejidad (nombre, factor) values ('media',1.5)
insert into complejidad (nombre, factor) values ('avanzada',2.0)
GO

/* ORDEN_COMPRA */
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10002,10001, CAST(N'2020-02-07' AS Date)),
  (10004,10004, CAST(N'2018-11-16' AS Date)),
  (10002,10003, CAST(N'2020-04-30' AS Date)),
  (10002,10005, CAST(N'2017-02-09' AS Date)),
  (10004,10001, CAST(N'2019-05-27' AS Date)),
  (10002,10005, CAST(N'2017-09-30' AS Date)),
  (10003,10004, CAST(N'2020-07-15' AS Date)),
  (10004,10002, CAST(N'2018-04-16' AS Date)),
  (10001,10002, CAST(N'2019-06-10' AS Date)),
  (10004,10004, CAST(N'2020-03-30' AS Date)),
  (10003,10002, CAST(N'2021-07-13' AS Date)),
  (10001,10002, CAST(N'2017-12-14' AS Date)),
  (10004,10004, CAST(N'2019-05-10' AS Date)),
  (10004,10002, CAST(N'2021-10-08' AS Date)),
  (10005,10003, CAST(N'2019-08-11' AS Date)),
  (10002,10004, CAST(N'2017-02-19' AS Date)),
  (10002,10001, CAST(N'2017-02-17' AS Date)),
  (10004,10005, CAST(N'2018-12-29' AS Date)),
  (10005,10004, CAST(N'2020-03-11' AS Date)),
  (10004,10004, CAST(N'2020-11-01' AS Date)),
  (10002,10004, CAST(N'2015-01-04' AS Date)),
  (10002,10003, CAST(N'2016-08-15' AS Date)),
  (10003,10005, CAST(N'2021-12-30' AS Date)),
  (10005,10004, CAST(N'2016-04-15' AS Date)),
  (10004,10005, CAST(N'2015-08-13' AS Date)),
  (10004,10005, CAST(N'2020-08-17' AS Date)),
  (10002,10001, CAST(N'2018-02-16' AS Date)),
  (10002,10005, CAST(N'2017-04-16' AS Date)),
  (10002,10001, CAST(N'2021-12-27' AS Date)),
  (10005,10002, CAST(N'2021-08-03' AS Date)),
  (10003,10002, CAST(N'2021-11-24' AS Date)),
  (10002,10003, CAST(N'2016-08-23' AS Date)),
  (10002,10003, CAST(N'2020-10-25' AS Date)),
  (10003,10002, CAST(N'2021-08-15' AS Date)),
  (10004,10001, CAST(N'2018-07-13' AS Date)),
  (10004,10002, CAST(N'2020-02-10' AS Date)),
  (10004,10003, CAST(N'2020-06-22' AS Date)),
  (10002,10003, CAST(N'2020-01-04' AS Date)),
  (10002,10004, CAST(N'2021-04-17' AS Date)),
  (10004,10002, CAST(N'2018-09-06' AS Date)),
  (10003,10003, CAST(N'2020-04-19' AS Date)),
  (10003,10004, CAST(N'2020-04-02' AS Date)),
  (10002,10005, CAST(N'2016-11-25' AS Date)),
  (10005,10004, CAST(N'2015-06-06' AS Date)),
  (10001,10003, CAST(N'2017-07-06' AS Date)),
  (10003,10003, CAST(N'2015-01-01' AS Date)),
  (10002,10002, CAST(N'2020-10-12' AS Date)),
  (10005,10003, CAST(N'2019-07-17' AS Date)),
  (10005,10002, CAST(N'2021-02-07' AS Date)),
  (10004,10001, CAST(N'2018-02-17' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10003,10005, CAST(N'2022-02-18' AS Date)),
  (10004,10003, CAST(N'2020-04-14' AS Date)),
  (10004,10002, CAST(N'2018-12-26' AS Date)),
  (10005,10003, CAST(N'2022-01-13' AS Date)),
  (10002,10005, CAST(N'2020-02-16' AS Date)),
  (10005,10003, CAST(N'2019-06-30' AS Date)),
  (10001,10004, CAST(N'2019-02-09' AS Date)),
  (10003,10003, CAST(N'2022-04-21' AS Date)),
  (10001,10001, CAST(N'2020-08-26' AS Date)),
  (10003,10002, CAST(N'2019-08-01' AS Date)),
  (10003,10002, CAST(N'2022-04-05' AS Date)),
  (10001,10001, CAST(N'2018-10-18' AS Date)),
  (10002,10002, CAST(N'2018-08-04' AS Date)),
  (10002,10004, CAST(N'2018-08-09' AS Date)),
  (10002,10003, CAST(N'2022-01-22' AS Date)),
  (10005,10003, CAST(N'2020-06-08' AS Date)),
  (10002,10003, CAST(N'2022-05-19' AS Date)),
  (10005,10004, CAST(N'2015-05-11' AS Date)),
  (10003,10002, CAST(N'2020-09-21' AS Date)),
  (10002,10002, CAST(N'2018-05-17' AS Date)),
  (10002,10003, CAST(N'2019-05-30' AS Date)),
  (10002,10001, CAST(N'2021-07-21' AS Date)),
  (10001,10004, CAST(N'2019-08-03' AS Date)),
  (10003,10004, CAST(N'2016-01-20' AS Date)),
  (10001,10003, CAST(N'2021-05-03' AS Date)),
  (10002,10003, CAST(N'2018-08-02' AS Date)),
  (10003,10003, CAST(N'2018-12-30' AS Date)),
  (10003,10002, CAST(N'2015-07-23' AS Date)),
  (10004,10002, CAST(N'2017-05-18' AS Date)),
  (10004,10002, CAST(N'2020-10-16' AS Date)),
  (10003,10005, CAST(N'2019-03-22' AS Date)),
  (10005,10004, CAST(N'2016-05-31' AS Date)),
  (10003,10004, CAST(N'2021-02-01' AS Date)),
  (10005,10003, CAST(N'2018-03-27' AS Date)),
  (10004,10003, CAST(N'2020-12-10' AS Date)),
  (10003,10004, CAST(N'2019-09-09' AS Date)),
  (10004,10003, CAST(N'2020-04-21' AS Date)),
  (10003,10004, CAST(N'2022-03-10' AS Date)),
  (10005,10005, CAST(N'2016-06-17' AS Date)),
  (10002,10002, CAST(N'2015-11-22' AS Date)),
  (10004,10002, CAST(N'2017-04-04' AS Date)),
  (10002,10002, CAST(N'2019-05-09' AS Date)),
  (10002,10002, CAST(N'2021-11-01' AS Date)),
  (10003,10004, CAST(N'2015-04-02' AS Date)),
  (10003,10004, CAST(N'2021-06-12' AS Date)),
  (10004,10001, CAST(N'2017-06-28' AS Date)),
  (10002,10001, CAST(N'2018-03-21' AS Date)),
  (10002,10003, CAST(N'2018-11-16' AS Date)),
  (10004,10003, CAST(N'2017-05-10' AS Date)),
  (10002,10003, CAST(N'2019-11-22' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10003,10004, CAST(N'2017-12-30' AS Date)),
  (10002,10003, CAST(N'2016-10-01' AS Date)),
  (10002,10004, CAST(N'2017-12-09' AS Date)),
  (10002,10003, CAST(N'2021-02-17' AS Date)),
  (10004,10004, CAST(N'2018-09-01' AS Date)),
  (10003,10002, CAST(N'2020-12-22' AS Date)),
  (10002,10003, CAST(N'2015-12-26' AS Date)),
  (10004,10002, CAST(N'2020-10-21' AS Date)),
  (10004,10001, CAST(N'2017-09-24' AS Date)),
  (10003,10002, CAST(N'2016-08-21' AS Date)),
  (10003,10005, CAST(N'2015-05-21' AS Date)),
  (10002,10004, CAST(N'2018-03-05' AS Date)),
  (10003,10003, CAST(N'2018-10-08' AS Date)),
  (10005,10004, CAST(N'2016-12-30' AS Date)),
  (10001,10003, CAST(N'2016-07-05' AS Date)),
  (10002,10004, CAST(N'2018-07-29' AS Date)),
  (10004,10004, CAST(N'2022-02-08' AS Date)),
  (10002,10002, CAST(N'2021-10-26' AS Date)),
  (10004,10003, CAST(N'2016-03-14' AS Date)),
  (10001,10004, CAST(N'2019-07-15' AS Date)),
  (10004,10002, CAST(N'2018-10-30' AS Date)),
  (10004,10004, CAST(N'2021-10-02' AS Date)),
  (10003,10004, CAST(N'2017-04-16' AS Date)),
  (10003,10004, CAST(N'2020-04-05' AS Date)),
  (10004,10002, CAST(N'2015-10-23' AS Date)),
  (10005,10001, CAST(N'2020-09-27' AS Date)),
  (10005,10001, CAST(N'2016-06-01' AS Date)),
  (10002,10003, CAST(N'2017-11-24' AS Date)),
  (10003,10003, CAST(N'2015-04-18' AS Date)),
  (10001,10003, CAST(N'2016-02-20' AS Date)),
  (10002,10005, CAST(N'2020-02-09' AS Date)),
  (10002,10004, CAST(N'2021-12-01' AS Date)),
  (10003,10003, CAST(N'2015-02-11' AS Date)),
  (10004,10004, CAST(N'2021-09-25' AS Date)),
  (10004,10004, CAST(N'2018-03-18' AS Date)),
  (10001,10004, CAST(N'2022-04-13' AS Date)),
  (10004,10004, CAST(N'2017-03-27' AS Date)),
  (10004,10004, CAST(N'2015-07-29' AS Date)),
  (10001,10005, CAST(N'2019-01-14' AS Date)),
  (10002,10002, CAST(N'2017-05-23' AS Date)),
  (10002,10003, CAST(N'2016-08-16' AS Date)),
  (10004,10004, CAST(N'2020-07-16' AS Date)),
  (10002,10003, CAST(N'2017-05-22' AS Date)),
  (10001,10004, CAST(N'2020-04-13' AS Date)),
  (10003,10003, CAST(N'2016-02-25' AS Date)),
  (10004,10002, CAST(N'2017-07-08' AS Date)),
  (10003,10002, CAST(N'2015-07-17' AS Date)),
  (10003,10003, CAST(N'2021-09-30' AS Date)),
  (10004,10003, CAST(N'2022-01-25' AS Date)),
  (10005,10005, CAST(N'2016-11-23' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10001,10004, CAST(N'2019-11-28' AS Date)),
  (10003,10001, CAST(N'2020-01-16' AS Date)),
  (10001,10003, CAST(N'2016-12-15' AS Date)),
  (10003,10001, CAST(N'2019-04-20' AS Date)),
  (10003,10003, CAST(N'2015-10-29' AS Date)),
  (10004,10003, CAST(N'2019-05-10' AS Date)),
  (10003,10003, CAST(N'2020-06-19' AS Date)),
  (10002,10002, CAST(N'2018-03-16' AS Date)),
  (10001,10003, CAST(N'2020-10-27' AS Date)),
  (10002,10005, CAST(N'2018-10-24' AS Date)),
  (10001,10003, CAST(N'2017-08-02' AS Date)),
  (10004,10003, CAST(N'2016-08-24' AS Date)),
  (10005,10004, CAST(N'2015-07-21' AS Date)),
  (10002,10003, CAST(N'2019-03-30' AS Date)),
  (10004,10002, CAST(N'2022-01-31' AS Date)),
  (10005,10003, CAST(N'2015-03-17' AS Date)),
  (10003,10004, CAST(N'2017-01-15' AS Date)),
  (10003,10003, CAST(N'2019-07-21' AS Date)),
  (10001,10002, CAST(N'2019-10-20' AS Date)),
  (10004,10004, CAST(N'2018-02-24' AS Date)),
  (10003,10004, CAST(N'2021-01-09' AS Date)),
  (10005,10004, CAST(N'2015-06-11' AS Date)),
  (10004,10004, CAST(N'2021-05-23' AS Date)),
  (10004,10002, CAST(N'2015-02-10' AS Date)),
  (10004,10003, CAST(N'2018-02-13' AS Date)),
  (10005,10001, CAST(N'2018-10-18' AS Date)),
  (10002,10003, CAST(N'2019-12-02' AS Date)),
  (10002,10003, CAST(N'2019-03-02' AS Date)),
  (10004,10004, CAST(N'2018-09-27' AS Date)),
  (10001,10004, CAST(N'2015-01-05' AS Date)),
  (10005,10003, CAST(N'2020-09-07' AS Date)),
  (10002,10003, CAST(N'2017-10-28' AS Date)),
  (10005,10002, CAST(N'2018-06-17' AS Date)),
  (10002,10004, CAST(N'2017-02-11' AS Date)),
  (10004,10002, CAST(N'2018-01-16' AS Date)),
  (10005,10005, CAST(N'2016-06-24' AS Date)),
  (10004,10002, CAST(N'2019-02-17' AS Date)),
  (10004,10002, CAST(N'2017-09-30' AS Date)),
  (10003,10003, CAST(N'2017-07-21' AS Date)),
  (10004,10002, CAST(N'2020-09-20' AS Date)),
  (10004,10001, CAST(N'2015-10-15' AS Date)),
  (10001,10004, CAST(N'2018-05-23' AS Date)),
  (10003,10004, CAST(N'2015-08-15' AS Date)),
  (10003,10002, CAST(N'2019-04-19' AS Date)),
  (10001,10002, CAST(N'2021-12-12' AS Date)),
  (10005,10002, CAST(N'2020-01-09' AS Date)),
  (10001,10003, CAST(N'2015-04-04' AS Date)),
  (10002,10003, CAST(N'2017-01-17' AS Date)),
  (10002,10003, CAST(N'2020-02-27' AS Date)),
  (10003,10004, CAST(N'2018-05-14' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10004,10003, CAST(N'2019-12-08' AS Date)),
  (10005,10001, CAST(N'2021-04-05' AS Date)),
  (10003,10004, CAST(N'2019-04-06' AS Date)),
  (10004,10004, CAST(N'2019-02-22' AS Date)),
  (10005,10004, CAST(N'2019-12-02' AS Date)),
  (10001,10002, CAST(N'2022-03-27' AS Date)),
  (10005,10005, CAST(N'2016-11-18' AS Date)),
  (10003,10004, CAST(N'2015-06-04' AS Date)),
  (10005,10002, CAST(N'2018-05-05' AS Date)),
  (10002,10003, CAST(N'2015-10-20' AS Date)),
  (10001,10002, CAST(N'2022-05-05' AS Date)),
  (10004,10003, CAST(N'2019-02-25' AS Date)),
  (10002,10003, CAST(N'2019-10-15' AS Date)),
  (10002,10003, CAST(N'2021-12-03' AS Date)),
  (10004,10003, CAST(N'2020-01-26' AS Date)),
  (10004,10002, CAST(N'2016-06-30' AS Date)),
  (10003,10002, CAST(N'2017-02-08' AS Date)),
  (10002,10003, CAST(N'2016-12-08' AS Date)),
  (10004,10002, CAST(N'2016-01-18' AS Date)),
  (10004,10003, CAST(N'2017-05-17' AS Date)),
  (10001,10002, CAST(N'2021-02-08' AS Date)),
  (10003,10004, CAST(N'2015-11-06' AS Date)),
  (10004,10003, CAST(N'2021-03-06' AS Date)),
  (10004,10005, CAST(N'2020-08-21' AS Date)),
  (10003,10002, CAST(N'2015-10-15' AS Date)),
  (10003,10004, CAST(N'2017-01-23' AS Date)),
  (10004,10003, CAST(N'2017-02-10' AS Date)),
  (10003,10001, CAST(N'2020-01-06' AS Date)),
  (10004,10004, CAST(N'2016-07-17' AS Date)),
  (10002,10003, CAST(N'2018-10-06' AS Date)),
  (10002,10005, CAST(N'2017-11-02' AS Date)),
  (10002,10002, CAST(N'2017-11-22' AS Date)),
  (10002,10003, CAST(N'2017-04-03' AS Date)),
  (10003,10004, CAST(N'2020-01-11' AS Date)),
  (10004,10003, CAST(N'2020-09-11' AS Date)),
  (10002,10003, CAST(N'2022-01-21' AS Date)),
  (10005,10004, CAST(N'2019-09-30' AS Date)),
  (10003,10004, CAST(N'2020-12-21' AS Date)),
  (10004,10002, CAST(N'2015-12-14' AS Date)),
  (10002,10003, CAST(N'2021-12-23' AS Date)),
  (10001,10004, CAST(N'2016-11-22' AS Date)),
  (10003,10001, CAST(N'2017-08-21' AS Date)),
  (10004,10003, CAST(N'2021-11-11' AS Date)),
  (10004,10002, CAST(N'2016-07-31' AS Date)),
  (10004,10004, CAST(N'2018-08-08' AS Date)),
  (10003,10004, CAST(N'2020-10-16' AS Date)),
  (10004,10003, CAST(N'2020-11-28' AS Date)),
  (10003,10004, CAST(N'2019-01-02' AS Date)),
  (10002,10002, CAST(N'2019-03-30' AS Date)),
  (10003,10004, CAST(N'2018-01-10' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10003,10002, CAST(N'2019-07-04' AS Date)),
  (10004,10002, CAST(N'2021-05-05' AS Date)),
  (10004,10003, CAST(N'2019-07-13' AS Date)),
  (10004,10001, CAST(N'2020-03-09' AS Date)),
  (10005,10005, CAST(N'2020-01-04' AS Date)),
  (10001,10005, CAST(N'2015-06-13' AS Date)),
  (10003,10002, CAST(N'2021-08-28' AS Date)),
  (10001,10003, CAST(N'2021-02-24' AS Date)),
  (10004,10005, CAST(N'2015-01-22' AS Date)),
  (10004,10003, CAST(N'2018-03-12' AS Date)),
  (10002,10005, CAST(N'2021-10-23' AS Date)),
  (10005,10005, CAST(N'2020-08-16' AS Date)),
  (10003,10005, CAST(N'2019-04-19' AS Date)),
  (10005,10004, CAST(N'2022-05-14' AS Date)),
  (10003,10001, CAST(N'2021-05-11' AS Date)),
  (10005,10001, CAST(N'2015-06-13' AS Date)),
  (10001,10004, CAST(N'2016-06-10' AS Date)),
  (10003,10003, CAST(N'2016-02-11' AS Date)),
  (10004,10002, CAST(N'2015-05-06' AS Date)),
  (10005,10002, CAST(N'2017-01-07' AS Date)),
  (10002,10004, CAST(N'2022-01-24' AS Date)),
  (10002,10003, CAST(N'2021-10-28' AS Date)),
  (10002,10002, CAST(N'2018-09-01' AS Date)),
  (10002,10001, CAST(N'2015-01-13' AS Date)),
  (10004,10004, CAST(N'2019-04-05' AS Date)),
  (10004,10002, CAST(N'2017-07-08' AS Date)),
  (10004,10003, CAST(N'2021-01-12' AS Date)),
  (10005,10004, CAST(N'2021-12-09' AS Date)),
  (10002,10005, CAST(N'2022-04-26' AS Date)),
  (10003,10005, CAST(N'2017-04-23' AS Date)),
  (10002,10004, CAST(N'2017-06-20' AS Date)),
  (10005,10004, CAST(N'2016-08-15' AS Date)),
  (10003,10002, CAST(N'2017-09-21' AS Date)),
  (10004,10002, CAST(N'2019-01-23' AS Date)),
  (10004,10002, CAST(N'2021-08-16' AS Date)),
  (10003,10003, CAST(N'2021-04-12' AS Date)),
  (10002,10001, CAST(N'2021-04-22' AS Date)),
  (10002,10004, CAST(N'2017-03-01' AS Date)),
  (10003,10004, CAST(N'2017-01-24' AS Date)),
  (10001,10002, CAST(N'2019-12-29' AS Date)),
  (10005,10003, CAST(N'2015-06-13' AS Date)),
  (10004,10002, CAST(N'2015-09-09' AS Date)),
  (10002,10003, CAST(N'2017-01-29' AS Date)),
  (10002,10004, CAST(N'2018-01-10' AS Date)),
  (10004,10005, CAST(N'2017-06-12' AS Date)),
  (10002,10003, CAST(N'2015-05-27' AS Date)),
  (10003,10001, CAST(N'2017-11-06' AS Date)),
  (10004,10001, CAST(N'2020-11-04' AS Date)),
  (10003,10005, CAST(N'2017-08-04' AS Date)),
  (10001,10003, CAST(N'2022-05-18' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10002,10001, CAST(N'2018-01-14' AS Date)),
  (10003,10001, CAST(N'2018-09-29' AS Date)),
  (10003,10004, CAST(N'2016-03-29' AS Date)),
  (10003,10003, CAST(N'2021-02-12' AS Date)),
  (10004,10003, CAST(N'2018-10-27' AS Date)),
  (10002,10002, CAST(N'2015-01-06' AS Date)),
  (10004,10001, CAST(N'2015-05-12' AS Date)),
  (10004,10004, CAST(N'2019-05-25' AS Date)),
  (10004,10002, CAST(N'2015-10-30' AS Date)),
  (10002,10001, CAST(N'2017-07-23' AS Date)),
  (10002,10002, CAST(N'2015-08-07' AS Date)),
  (10004,10003, CAST(N'2018-06-23' AS Date)),
  (10001,10003, CAST(N'2019-06-22' AS Date)),
  (10003,10004, CAST(N'2021-02-22' AS Date)),
  (10003,10004, CAST(N'2015-02-03' AS Date)),
  (10001,10005, CAST(N'2019-04-23' AS Date)),
  (10004,10003, CAST(N'2019-06-15' AS Date)),
  (10002,10004, CAST(N'2021-11-21' AS Date)),
  (10003,10005, CAST(N'2019-07-04' AS Date)),
  (10002,10003, CAST(N'2021-10-26' AS Date)),
  (10003,10005, CAST(N'2021-01-20' AS Date)),
  (10002,10003, CAST(N'2017-07-22' AS Date)),
  (10003,10001, CAST(N'2017-06-21' AS Date)),
  (10003,10005, CAST(N'2018-10-05' AS Date)),
  (10003,10001, CAST(N'2019-12-23' AS Date)),
  (10004,10002, CAST(N'2016-07-24' AS Date)),
  (10003,10004, CAST(N'2015-03-20' AS Date)),
  (10002,10002, CAST(N'2017-11-01' AS Date)),
  (10003,10004, CAST(N'2017-07-11' AS Date)),
  (10002,10004, CAST(N'2020-09-28' AS Date)),
  (10003,10002, CAST(N'2020-08-06' AS Date)),
  (10002,10003, CAST(N'2017-09-29' AS Date)),
  (10003,10003, CAST(N'2021-12-13' AS Date)),
  (10002,10001, CAST(N'2018-05-03' AS Date)),
  (10004,10002, CAST(N'2016-11-06' AS Date)),
  (10003,10002, CAST(N'2015-08-23' AS Date)),
  (10003,10005, CAST(N'2016-07-06' AS Date)),
  (10002,10003, CAST(N'2018-12-03' AS Date)),
  (10003,10002, CAST(N'2017-08-20' AS Date)),
  (10003,10004, CAST(N'2015-08-28' AS Date)),
  (10003,10005, CAST(N'2021-04-28' AS Date)),
  (10001,10003, CAST(N'2020-09-09' AS Date)),
  (10003,10003, CAST(N'2017-03-17' AS Date)),
  (10004,10004, CAST(N'2016-09-11' AS Date)),
  (10001,10003, CAST(N'2019-05-08' AS Date)),
  (10002,10002, CAST(N'2016-01-04' AS Date)),
  (10005,10002, CAST(N'2015-10-12' AS Date)),
  (10003,10004, CAST(N'2020-10-01' AS Date)),
  (10001,10002, CAST(N'2017-04-14' AS Date)),
  (10003,10002, CAST(N'2018-12-03' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10003,10005, CAST(N'2019-10-01' AS Date)),
  (10002,10003, CAST(N'2021-01-10' AS Date)),
  (10003,10002, CAST(N'2019-03-01' AS Date)),
  (10005,10003, CAST(N'2020-09-08' AS Date)),
  (10004,10001, CAST(N'2016-06-19' AS Date)),
  (10003,10005, CAST(N'2019-04-04' AS Date)),
  (10001,10001, CAST(N'2016-11-26' AS Date)),
  (10003,10001, CAST(N'2021-03-07' AS Date)),
  (10003,10004, CAST(N'2019-02-03' AS Date)),
  (10004,10005, CAST(N'2015-02-12' AS Date)),
  (10003,10005, CAST(N'2019-12-02' AS Date)),
  (10002,10004, CAST(N'2021-08-23' AS Date)),
  (10004,10001, CAST(N'2020-01-20' AS Date)),
  (10005,10005, CAST(N'2019-09-09' AS Date)),
  (10004,10004, CAST(N'2022-02-17' AS Date)),
  (10002,10004, CAST(N'2018-11-07' AS Date)),
  (10003,10005, CAST(N'2017-01-26' AS Date)),
  (10003,10001, CAST(N'2020-02-24' AS Date)),
  (10001,10003, CAST(N'2017-11-06' AS Date)),
  (10002,10005, CAST(N'2020-09-03' AS Date)),
  (10001,10003, CAST(N'2020-03-02' AS Date)),
  (10003,10001, CAST(N'2020-12-30' AS Date)),
  (10002,10002, CAST(N'2021-08-26' AS Date)),
  (10003,10005, CAST(N'2021-08-27' AS Date)),
  (10002,10003, CAST(N'2016-05-18' AS Date)),
  (10002,10004, CAST(N'2018-12-15' AS Date)),
  (10001,10002, CAST(N'2018-03-10' AS Date)),
  (10002,10003, CAST(N'2021-01-21' AS Date)),
  (10003,10002, CAST(N'2017-01-18' AS Date)),
  (10005,10002, CAST(N'2017-12-12' AS Date)),
  (10001,10003, CAST(N'2022-03-03' AS Date)),
  (10001,10004, CAST(N'2016-02-24' AS Date)),
  (10005,10002, CAST(N'2019-03-10' AS Date)),
  (10004,10005, CAST(N'2016-11-02' AS Date)),
  (10003,10004, CAST(N'2020-10-07' AS Date)),
  (10002,10004, CAST(N'2016-02-01' AS Date)),
  (10005,10002, CAST(N'2017-06-02' AS Date)),
  (10001,10002, CAST(N'2020-10-09' AS Date)),
  (10005,10003, CAST(N'2017-11-03' AS Date)),
  (10004,10001, CAST(N'2022-02-26' AS Date)),
  (10001,10003, CAST(N'2021-07-18' AS Date)),
  (10003,10004, CAST(N'2017-12-14' AS Date)),
  (10002,10001, CAST(N'2020-12-08' AS Date)),
  (10001,10002, CAST(N'2021-12-26' AS Date)),
  (10003,10002, CAST(N'2016-03-24' AS Date)),
  (10002,10003, CAST(N'2017-04-29' AS Date)),
  (10002,10001, CAST(N'2022-05-15' AS Date)),
  (10003,10002, CAST(N'2021-04-06' AS Date)),
  (10002,10004, CAST(N'2016-10-09' AS Date)),
  (10004,10004, CAST(N'2017-11-10' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10004,10004, CAST(N'2019-10-26' AS Date)),
  (10003,10001, CAST(N'2022-05-03' AS Date)),
  (10001,10003, CAST(N'2018-09-26' AS Date)),
  (10003,10001, CAST(N'2016-08-23' AS Date)),
  (10004,10002, CAST(N'2015-11-01' AS Date)),
  (10004,10004, CAST(N'2019-06-05' AS Date)),
  (10002,10002, CAST(N'2015-11-27' AS Date)),
  (10002,10004, CAST(N'2016-03-23' AS Date)),
  (10004,10003, CAST(N'2020-03-30' AS Date)),
  (10001,10004, CAST(N'2019-07-04' AS Date)),
  (10003,10004, CAST(N'2022-04-21' AS Date)),
  (10003,10003, CAST(N'2021-01-03' AS Date)),
  (10001,10002, CAST(N'2018-01-14' AS Date)),
  (10003,10003, CAST(N'2020-02-20' AS Date)),
  (10004,10005, CAST(N'2017-09-06' AS Date)),
  (10001,10005, CAST(N'2015-11-27' AS Date)),
  (10001,10004, CAST(N'2017-12-13' AS Date)),
  (10003,10003, CAST(N'2019-04-22' AS Date)),
  (10003,10001, CAST(N'2022-04-24' AS Date)),
  (10002,10002, CAST(N'2017-08-24' AS Date)),
  (10005,10003, CAST(N'2019-09-17' AS Date)),
  (10001,10004, CAST(N'2015-11-29' AS Date)),
  (10004,10004, CAST(N'2022-04-06' AS Date)),
  (10002,10003, CAST(N'2015-10-10' AS Date)),
  (10001,10003, CAST(N'2020-08-24' AS Date)),
  (10002,10002, CAST(N'2022-05-18' AS Date)),
  (10002,10002, CAST(N'2022-04-21' AS Date)),
  (10004,10001, CAST(N'2016-06-02' AS Date)),
  (10003,10002, CAST(N'2020-05-10' AS Date)),
  (10002,10004, CAST(N'2016-11-16' AS Date)),
  (10005,10004, CAST(N'2017-06-07' AS Date)),
  (10003,10002, CAST(N'2016-06-21' AS Date)),
  (10002,10003, CAST(N'2015-02-08' AS Date)),
  (10003,10004, CAST(N'2015-12-31' AS Date)),
  (10002,10003, CAST(N'2018-04-14' AS Date)),
  (10002,10004, CAST(N'2015-03-21' AS Date)),
  (10003,10003, CAST(N'2021-10-10' AS Date)),
  (10002,10004, CAST(N'2019-12-29' AS Date)),
  (10002,10003, CAST(N'2016-06-30' AS Date)),
  (10002,10004, CAST(N'2016-10-24' AS Date)),
  (10002,10003, CAST(N'2016-01-02' AS Date)),
  (10003,10002, CAST(N'2019-02-22' AS Date)),
  (10005,10004, CAST(N'2016-05-24' AS Date)),
  (10001,10003, CAST(N'2019-04-12' AS Date)),
  (10002,10003, CAST(N'2015-03-31' AS Date)),
  (10002,10001, CAST(N'2021-12-15' AS Date)),
  (10001,10002, CAST(N'2015-08-26' AS Date)),
  (10004,10004, CAST(N'2018-06-27' AS Date)),
  (10004,10003, CAST(N'2020-02-18' AS Date)),
  (10003,10001, CAST(N'2018-01-16' AS Date));
INSERT INTO [orden_compra] (id_empleado,id_proveedor,fecha_compra)
VALUES
  (10002,10002, CAST(N'2020-09-08' AS Date)),
  (10002,10003, CAST(N'2017-12-27' AS Date)),
  (10005,10002, CAST(N'2017-07-11' AS Date)),
  (10001,10004, CAST(N'2017-12-03' AS Date)),
  (10002,10001, CAST(N'2019-03-06' AS Date)),
  (10004,10002, CAST(N'2019-09-19' AS Date)),
  (10002,10003, CAST(N'2018-04-16' AS Date)),
  (10001,10003, CAST(N'2015-08-08' AS Date)),
  (10002,10004, CAST(N'2018-12-06' AS Date)),
  (10004,10002, CAST(N'2019-03-31' AS Date)),
  (10001,10002, CAST(N'2015-10-07' AS Date)),
  (10002,10004, CAST(N'2020-12-02' AS Date)),
  (10001,10003, CAST(N'2020-08-13' AS Date)),
  (10002,10002, CAST(N'2017-03-28' AS Date)),
  (10001,10002, CAST(N'2017-09-27' AS Date)),
  (10002,10002, CAST(N'2017-07-09' AS Date)),
  (10004,10001, CAST(N'2017-01-19' AS Date)),
  (10001,10002, CAST(N'2020-01-05' AS Date)),
  (10004,10003, CAST(N'2017-07-06' AS Date)),
  (10005,10002, CAST(N'2019-08-02' AS Date)),
  (10002,10002, CAST(N'2018-04-05' AS Date)),
  (10004,10002, CAST(N'2019-07-08' AS Date)),
  (10004,10004, CAST(N'2017-04-06' AS Date)),
  (10004,10004, CAST(N'2022-03-13' AS Date)),
  (10004,10001, CAST(N'2020-07-01' AS Date)),
  (10005,10001, CAST(N'2022-03-29' AS Date)),
  (10003,10002, CAST(N'2017-12-22' AS Date)),
  (10004,10001, CAST(N'2017-10-04' AS Date)),
  (10004,10004, CAST(N'2018-09-23' AS Date)),
  (10004,10004, CAST(N'2019-11-16' AS Date)),
  (10001,10001, CAST(N'2020-11-30' AS Date)),
  (10001,10003, CAST(N'2017-10-06' AS Date)),
  (10003,10002, CAST(N'2017-07-31' AS Date)),
  (10004,10003, CAST(N'2017-06-10' AS Date)),
  (10003,10003, CAST(N'2015-07-02' AS Date)),
  (10005,10002, CAST(N'2022-01-26' AS Date)),
  (10005,10002, CAST(N'2017-01-16' AS Date)),
  (10003,10001, CAST(N'2018-12-04' AS Date)),
  (10003,10004, CAST(N'2015-10-06' AS Date)),
  (10003,10002, CAST(N'2020-09-30' AS Date)),
  (10001,10002, CAST(N'2019-07-26' AS Date)),
  (10002,10004, CAST(N'2021-09-18' AS Date)),
  (10002,10004, CAST(N'2022-02-15' AS Date)),
  (10004,10004, CAST(N'2017-02-05' AS Date)),
  (10005,10002, CAST(N'2015-01-23' AS Date)),
  (10003,10004, CAST(N'2020-01-17' AS Date)),
  (10003,10004, CAST(N'2019-01-17' AS Date)),
  (10005,10002, CAST(N'2016-11-28' AS Date)),
  (10001,10004, CAST(N'2022-01-14' AS Date)),
  (10002,10002, CAST(N'2017-12-26' AS Date));
GO