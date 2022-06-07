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

Create Database DB_VENTAS_COMPRAS_STAGE

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
	num_dia_mes smallint
)

create table stg_categoria (
	sk_categoria int identity (5000,1) primary key,
	cod_categoria int,
	id int not null,
	categoria nvarchar(50) not null,
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
	id int not null,
	nombre nvarchar(50) not null,
	categoria_servicio nvarchar(50) not null,
	precio_base decimal(10,2) not null
);

create table stg_complejidad (
	sk_complejidad int identity (5000,1) primary key,
	cod_complejidad int,
	id int not null,
	nombre nvarchar(50) not null,
	factor decimal (3,2) not null
);

create table stg_junk_metodo_estado(
	sk_metodo_estado int identity (5000,1) primary key,
	id int not null,
	metodo_pago nvarchar(50) not null,
	estado_pago nvarchar(50) not null
);

create table stg_persona(
	sk_persona int identity (5000,1) primary key,
	cod_persona int not null,
	nombre_completo varchar(50) not null,
	identificacion varchar(50) not null,
	tipo_persona varchar(50) not null
)
GO


DECLARE @FechaDesde date,@FechaHasta date

DECLARE @Sk_Fecha int,
        @FechaEvaluada date,@Anio int,
		@Semestre nvarchar(30),@Trimestre nvarchar(30),@Mes nvarchar(30),@DiaSemana nvarchar(30)
DECLARE @NumSemestreAnio smallint,@NumTrimestreAnio smallint,@NumMesAnio smallint,
        @NumDiaSemana smallint,@NumDiaMes smallint



--Set inicial por si no coincide con los del servidor
SET DATEFORMAT dmy
SET DATEFIRST 1

BEGIN TRANSACTION
    --Borrar datos de la tabla STG_Fechas
    TRUNCATE TABLE  STG_Fechas
   
    --Rango de fechas a generar: del 01/01/2017 al 31/12/2020
    SELECT @FechaDesde = CAST('20150101' AS date)
	SELECT @FechaHasta = CAST('20220601' AS date)

	--Carga la variable @FechaEvaluada con el valor inicial de la @FechaDesde
	SET @FechaEvaluada = @FechaDesde
    
	--Esta línea permite agregar 2 años mas al año actual, se deja como ejemplo
	--SELECT @FechaHasta = CAST(CAST(YEAR(GETDATE())+2 AS CHAR(4)) + '1231' AS smalldatetime)

    --Inicio de BUCLE para insertar registros en la tabla STG_FECHAS
    WHILE (@FechaEvaluada <= @FechaHasta) --Mientras @FechaEvaluada sea menor o igual a la @FechaHasta
	   BEGIN
            --Obtiene el valor para el campo SK_FECHA en formato número YYYYMMDD de la @FechaEvaluada
			SELECT @Sk_Fecha = YEAR(@FechaEvaluada)*10000 + MONTH(@FechaEvaluada)*100 + DATEPART(dd, @FechaEvaluada)
            --Obtiene el año de la @FechaEvaluada
			SELECT @Anio = DATEPART(yy, @FechaEvaluada)
			--Obtiene la descripción del semestre de la @FechaEvaluada
			SELECT @Semestre = CASE
							     WHEN Month(@FechaEvaluada) <= 6 THEN 'Semestre 1' 
								 ELSE 'Semestre 2'
							   END
             --Obtiene la descripción del trimestre de la @FechaEvaluada
			SELECT @Trimestre = CASE
							     WHEN Month(@FechaEvaluada) <= 3 THEN 'Trimestre 1' 
								 WHEN Month(@FechaEvaluada) <= 6 THEN 'Trimestre 2'
								 WHEN Month(@FechaEvaluada) <= 9 THEN 'Trimestre 3'
								 ELSE 'Trimestre 4'
							   END
			 --Obtiene la descripción del mes de la @FechaEvaluada
			SELECT @Mes = CASE
								WHEN Month(@FechaEvaluada) = 1 THEN 'Enero' 
								WHEN Month(@FechaEvaluada) = 2 THEN 'Febrero'
								WHEN Month(@FechaEvaluada) = 3 THEN 'Marzo'
								WHEN Month(@FechaEvaluada) = 4 THEN 'Abril'
								WHEN Month(@FechaEvaluada) = 5 THEN 'Mayo' 
								WHEN Month(@FechaEvaluada) = 6 THEN 'Junio'
								WHEN Month(@FechaEvaluada) = 7 THEN 'Julio'
								WHEN Month(@FechaEvaluada) = 8 THEN 'Agosto'
								WHEN Month(@FechaEvaluada) = 9 THEN 'Setiembre' 
								WHEN Month(@FechaEvaluada) = 10 THEN 'Octubre'
								WHEN Month(@FechaEvaluada) = 11 THEN 'Noviembre'
								WHEN Month(@FechaEvaluada) = 12 THEN 'Diciembre'
						  END

			 --Obtiene la descripción del día de la semana de la @FechaEvaluada
			SELECT @DiaSemana = CASE
									WHEN DATEPART(dw, @FechaEvaluada) = 1 THEN 'Lunes'
									WHEN DATEPART(dw, @FechaEvaluada) = 2 THEN 'Martes'
									WHEN DATEPART(dw, @FechaEvaluada) = 3 THEN 'Miércoles'
									WHEN DATEPART(dw, @FechaEvaluada) = 4 THEN 'Jueves'
									WHEN DATEPART(dw, @FechaEvaluada) = 5 THEN 'Viernes'
									WHEN DATEPART(dw, @FechaEvaluada) = 6 THEN 'Sábado'
									WHEN DATEPART(dw, @FechaEvaluada) = 7 THEN 'Domingo' 									
								END
 
			--Obtiene la posición del semestre en el año de la @FechaEvaluada
			SELECT @NumSemestreAnio = CASE
										 WHEN Month(@FechaEvaluada) <= 6 THEN 1
										 ELSE 2
									   END

			--Obtiene la posición del trimestre en el año de la @FechaEvaluada
			SELECT @NumTrimestreAnio = CASE
										 WHEN Month(@FechaEvaluada) <= 3 THEN 1
										 WHEN Month(@FechaEvaluada) <= 6 THEN 2
										 WHEN Month(@FechaEvaluada) <= 9 THEN 3
										 ELSE 4
									   END

			--Obtiene la posición del mes en el año de la @FechaEvaluada
			SELECT @NumMesAnio = Month(@FechaEvaluada)

			--Obtiene la posición del día de la semana de la @FechaEvaluada
			SELECT @NumDiaSemana = DATEPART(dw, @FechaEvaluada)

			--Obtiene la posición del día del mes de la @FechaEvaluada
			SELECT @NumDiaMes = DAY(@FechaEvaluada)

			--Inserta el registro con los valores extraídos de la @FechaEvaluada en la tabla STG_Fechas
	
			INSERT INTO STG_Fechas
			(	sk_fecha,fecha,anio,semestre,trimestre,mes,dia_semana,
			    num_semestre_anio, num_trimestre_anio, num_mes_anio,num_dia_semana,num_dia_mes )
			VALUES
			(   @Sk_Fecha,@FechaEvaluada,@Anio,@Semestre,@Trimestre,@Mes,@DiaSemana,
			    @NumSemestreAnio,@NumTrimestreAnio,@NumMesAnio,@NumDiaSemana,@NumDiaMes )
				
   
			--Incremento el valor de la @FechaEvaluada en un día
			SELECT @FechaEvaluada = DATEADD(DAY, 1, @FechaEvaluada)
    END
    COMMIT TRANSACTION