
USE master
GO

DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'OLTP_VENTAS_COMPRAS'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

--SELECT @SQL 
EXEC(@SQL)
GO

IF EXISTS(select * from sys.databases where name='OLTP_VENTAS_COMPRAS')
DROP DATABASE OLTP_VENTAS_COMPRAS;

CREATE DATABASE OLTP_VENTAS_COMPRAS;
GO

USE OLTP_VENTAS_COMPRAS;
GO

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