
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

create table metodo_pago(
id int identity(10000,1) primary key,
metodo_pago nvarchar(50) not null,
);

create table orden_venta(
id int identity (10000,1) primary key,
id_empleado int not null,
id_cliente int not null,
pago nvarchar(50) not null,
estado nvarchar(50) not null,
fecha_cotizacion date not null,
fecha_pago_propuesta date not null

foreign key (id_empleado) references empleado(id),
foreign key (id_cliente) references cliente(id)
);

create table detalle_venta_producto(
id_orden_venta int not null,
id_producto int not null,
cantidad int not null,

foreign key (id_orden_venta) references orden_venta (id),
foreign key (id_producto) references producto (id)
);

create table detalle_venta_servicios(
id_servicio int not null,
id_orden_venta int not null,
id_complejidad int not null,
categoria_servicio nvarchar(50)

foreign key (id_orden_venta) references orden_venta (id),
foreign key (id_complejidad) references complejidad (id)
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

insert into categoria (categoria) values ('RF & microwave')
insert into categoria (categoria) values ('Microcontrollers (MCUs) & processors')
insert into categoria (categoria) values ('Data converters')
insert into categoria (categoria) values ('Amplifiers')
insert into categoria (categoria) values ('Wireless connectivity')

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

insert into complejidad (nombre, factor) values ('simple',1.0)
insert into complejidad (nombre, factor) values ('media',1.5)
insert into complejidad (nombre, factor) values ('avanzada',2.0)