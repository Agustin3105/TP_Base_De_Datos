drop database if exists app;
create database if not exists app;
use app;


create table Persona(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
nombre varchar(20) not null,
apellido varchar(20) not null,
celular int,
email varchar(50),
direccion varchar(50),
codigoPostal int,
fechaDeNacimiento date not null,

constraint Persona_pk primary key (cuil, numeroDePaciente)
);

create table Profesional(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
matriculaProvincial int unique,
matriculaNacional int unique,

constraint Profesional_pk primary key (cuil, numeroDePaciente),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente)
);

create table CentroDeSalud(
codigo int primary key not null auto_increment,
nombre varchar(50) not null,
direccion varchar(50) not null
);

create table GravedadDeEfecto(
codigo int primary key not null auto_increment,
descripcion varchar(20) not null unique
);

create table EfectoAdverso(
codigo int primary key not null auto_increment,
descripcion varchar(50) not null,
codigoGravedad int not null,

constraint foreign key (codigoGravedad) references GravedadDeEfecto(codigo)
);

create table Diagnostico(
codigo int primary key not null, 
descripcion varchar(50) not null
);

create table Condicion(
codigo int primary key not null,
descripcion varchar(50) not null,
codigoDiagnostico int,

constraint foreign key (codigoDiagnostico) references Diagnostico(codigo)
);

create table Especialidad(
codigo int primary key not null auto_increment,
descripcion varchar(50) not null unique
);

create table FormaDeAdministracion(
codigo int primary key not null auto_increment,
descripcion varchar(20) not null unique
);

create table OrigenDeCompuesto(
codigo int primary key not null auto_increment,
descripcion varchar(20) not null unique
);

create table Farmaco(
codigo int primary key not null auto_increment,
descripcion varchar(50) not null unique
);

create table CompuestoFarmacologico(
codigoDeBarras int primary key not null, 
fechaVencimiento date not null,
fabricante varchar(50) not null,
numeroDeLote int, 
partida int,
codigoOrigen int not null,
codigoFormaAdministracion int not null,

constraint foreign key (codigoOrigen) references OrigenDeCompuesto(codigo),
foreign key (codigoFormaAdministracion) references FormaDeAdministracion(codigo)
);

create table CodigoTratamiento(
codigo int primary key not null auto_increment,
lugarDelCuerpo varchar(50),
descripcion varchar(50) not null,
efectoEsperado varchar(50) not null,
invasivo boolean not null
);

create table Tratamiento(
codigoTratamiento int not null,
identificador int not null,
fechaHora datetime not null,
codigoCentroDeSalud int,
cuilProfesional bigint unsigned not null,
numeroDePacienteProfesional bigint unsigned not null,

constraint foreign key (cuilProfesional, numeroDePacienteProfesional) references Profesional(cuil, numeroDePaciente),
foreign key (codigoTratamiento) references CodigoTratamiento(codigo),
foreign key (codigoCentroDeSalud) references CentroDeSalud(codigo),
primary key Tratamiento_pk (codigoTratamiento, identificador)
);

create table PracticaQuirurgica(
codigoTratamiento int not null,
identificador int not null,
fueExitosa bool,

constraint foreign key (codigoTratamiento, identificador) references Tratamiento(codigoTratamiento, identificador),
primary key PracticaQuirurgica_pk (codigoTratamiento, identificador)
);

create table PracticaDiagnostica(
codigoTratamiento int not null,
identificador int not null,
diagnosticoPresuntivo varchar(50) not null,
seConfirmo bool not null,
codigoDiagnostico int, 

constraint foreign key (codigoTratamiento, identificador) references Tratamiento(codigoTratamiento, identificador),
primary key PracticaDiagnostica_pk (codigoTratamiento, identificador)
);

create table Condicion_Persona(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
codigoDeCondicion int not null,
fecha date,

constraint Condicion_Persona_pk primary key (cuil, numeroDePaciente, codigoDeCondicion),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente),
foreign key (codigoDeCondicion) references Condicion(codigo)
);


create table Persona_EfectoAdverso(
codigoEfecto int not null,
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
fechaHora datetime not null,

constraint primary key Persona_EfectoAdverso_pk (codigoEfecto, cuil, numeroDePaciente, fechaHora),
foreign key (codigoEfecto) references EfectoAdverso(codigo),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente)
);

create table Persona_Tratamiento(
codigoTratamiento int not null,
identificador int not null,
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
relacion varchar(20),

constraint primary key Persona_Tratamiento_pk (codigoTratamiento, identificador, cuil, numeroDePaciente),
foreign key (codigoTratamiento, identificador) references Tratamiento(codigoTratamiento, identificador),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente)
);

create table Contraindicacion(
codigoTratamiento int not null,
codigoCondicion int not null,
comprobado bool not null,

constraint Contraindicacion_pk primary key (codigoTratamiento, codigoCondicion),
foreign key (codigoTratamiento) references Tratamiento(codigoTratamiento),
foreign key (codigoCondicion) references Condicion(codigo)
);

create table Tratamiento_CompuestoFarmacologico(
codigoTratamiento int not null,
identificador int not null,
codigoCompuesto int not null,

constraint Tratamiento_CompuestoFarmacologico_pk primary key (codigoTratamiento, identificador, codigoCompuesto),
foreign key (codigoTratamiento, identificador) references Tratamiento(codigoTratamiento, identificador),
foreign key (codigoCompuesto) references CompuestoFarmacologico(codigoDeBarras)
);

create table Profesional_Especialidad(
cuil bigint unsigned not null, 
numeroDePaciente bigint unsigned not null, 
codigoEspecialidad int not null,

constraint Profesional_Especialidad_pk primary key (cuil, numeroDePaciente, codigoEspecialidad),
foreign key (cuil, numeroDePaciente) references Profesional(cuil, numeroDePaciente),
foreign key (codigoEspecialidad) references Especialidad(codigo)
);

create table ComposicionCompuestoFarmacologico(
codigoCompuesto int not null, 
codigoFarmaco int not null, 
cantidadEnMiligramos int, 
constraint ComposicionCompuestoFarmacologico_pk primary key (codigoCompuesto, codigoFarmaco, cantidadEnMiligramos),
foreign key (codigoCompuesto) references CompuestoFarmacologico(codigoDeBarras),
foreign key (codigoFarmaco) references Farmaco(codigo)
);

create table RangoEtario(
valor varchar(30) not null primary key,
edadMinima tinyint unsigned not null,
edadMaxima tinyint unsigned not null
);

-- Inserts para la tabla Persona
INSERT INTO Persona (cuil, numeroDePaciente, nombre, apellido, celular, email, direccion, codigoPostal, fechaDeNacimiento) 
VALUES (20000000001, 1, 'Juan', 'Perez', 1132345678, 'correo1@example.com', 'Jose Marmol 21', 12345, '1992-10-21'),
(20000000002, 2, 'Maria', 'Perez', 1145345678, 'correo2@example.com', 'Jose Juarez 21', 12345, '1972-04-11'), 
(20000000003, 3, 'Norberto', 'Alpozo', 1189765432, 'correo3@example.com', 'San Pedro 2211', 54321, '1939-03-28'),
(20000000004, 4,'Roberto', 'Alonso', 1198765432, 'correo4@example.com', 'San Pedro 2111', 54321, '1992-11-21'),
(20000000005, 5, 'Lidia', 'Martinez', 1112765432, 'correo10@example.com', 'Rivadavia 2911', 1321, '1997-08-03'),
(20000000006, 6, 'Marcos', 'Ayala', 1172365432, 'correo20@example.com', 'Belgrano 2211', 6721, '2012-12-21');

INSERT INTO Persona (cuil, numeroDePaciente, nombre, apellido, fechaDeNacimiento) 
VALUES(20000000007, 7, 'Jason', 'Martinez', '2023-05-31');

-- Inserts para la tabla Profesional
INSERT INTO Profesional (cuil, numeroDePaciente, matriculaProvincial, matriculaNacional)
VALUES (20000000001, 1, 11111, 22222),
(20000000002, 2, 33333, 44444);

-- Insert para la tabla GravedadDeEfecto
INSERT INTO GravedadDeEfecto (codigo, descripcion) 
VALUES (1, 'Leve'),(2, 'Moderado'),(3, 'Grave'),(4, 'Severo'),(5, 'Muerte');

-- Inserts para la tabla EfectoAdverso
INSERT INTO EfectoAdverso (descripcion, codigoGravedad) 
VALUES ('Paro Cardíaco', 5),('Pre-Infarto', 3),('Fiebre', 2),('Tos Seca', 1),('Fractura de Tibia', 4);

-- Inserts para la tabla Diagnostico
INSERT INTO Diagnostico (codigo, descripcion) 
VALUES (1, 'Arritmia Cardiaca'),(2, 'Bulimia'),(3, 'Cancer'), (4, 'Diabetes');

-- Inserts para la tabla Condicion
INSERT INTO Condicion (codigo, descripcion, codigoDiagnostico) 
VALUES (1, 'Arritmia Tipo A', 1),(2, 'Arritmia Tipo B', 1),(3, 'Leucemia', 3),
(4, 'Trastorno Alimenticio por Depresion', 2),(5, 'Diabetes Tipo 2', 4);

-- Inserts para la tabla OrigenDeCompuesto
INSERT INTO OrigenDeCompuesto (descripcion) 
VALUES ('Natural'),('Artificial');

-- Inserts para la tabla FormaDeAdministracion
INSERT INTO FormaDeAdministracion (descripcion)
VALUES ('Medicamento'),('Vacuna'),('Suero'),('Adyuvantes');

-- Inserts para la tabla CentroDeSalud
INSERT INTO CentroDeSalud (nombre, direccion) 
VALUES ('Centro Italiano', 'San Marcos 2134, Buenos Aires'),('Hospital Mayor', 'Tokyo 1234, Cordoba');

-- Inserts para la tabla Especialidad
INSERT INTO Especialidad (descripcion) VALUES ('Pediatra'),('Cirujano/a'),('Cardiologo/a'),('Nutricionista');

-- Inserts para la tabla Fármaco
INSERT INTO Farmaco (descripcion) VALUES ('Ibuprofeno'),('Morfina'),('Vacunitaximina');

-- Inserts para la tabla CompuestoFarmacologico
INSERT INTO CompuestoFarmacologico (codigoDeBarras, fechaVencimiento, fabricante, numeroDeLote, partida, codigoOrigen, codigoFormaAdministracion)
VALUES (123456, '2023-12-31', 'Pfizer', 1, 1, 1, 1),(789012, '2024-06-30', 'PSK', 2, 2, 2, 2), (989012, '2027-02-20', 'Roemmers', 2, 2, 2, 2);

-- Inserts para la tabla CodigoTratamiento
INSERT INTO CodigoTratamiento (lugarDelCuerpo, descripcion, efectoEsperado, invasivo) 
VALUES ('Brazo', 'Vacuna Cobid-29','Generacion de Anticuerpos', false),
('Rodilla', 'Operacion de Meniscos','Relocación del Hueso', true),
('Cuerpo Entero', 'Electrocardiograma', 'Descubrir enfermedad cadiológica', false), 
('Cuerpo Entero', 'Parto Natural', 'Completar Nacimiento', true);

-- Inserts para la tabla Tratamiento
INSERT INTO Tratamiento (codigoTratamiento, identificador, fechaHora, codigoCentroDeSalud, cuilProfesional, numeroDePacienteProfesional)
VALUES (1, 1, '2022-10-05 09:00:00', 1, 20000000001, 1), 
(1, 2, '2022-07-01 09:05:00', 1, 20000000001, 1),
(1, 3, '2023-01-01 10:00:00', 1, 20000000001, 1),
(1, 4, '2022-12-31 10:00:00', 1, 20000000001, 1),
(2, 1, '2022-03-04 09:30:00', 1, 20000000002, 2),
(2, 2, '2023-05-04 09:30:00', 1, 20000000002, 2),
(3, 1, '2022-11-23 14:30:00', 2, 20000000002, 2),
(4, 1, '2023-05-31 19:30:00', 2, 20000000001, 1);


-- Inserts para la tabla PracticaQuirurgica
INSERT INTO PracticaQuirurgica (codigoTratamiento, identificador, fueExitosa) 
VALUES (2, 1, true), (4, 1, false);

-- Inserts para la tabla PracticaDiagnostica
INSERT INTO PracticaDiagnostica (codigoTratamiento, identificador, diagnosticoPresuntivo, seConfirmo, codigoDiagnostico)
VALUES (3, 1, 'Arritmia Tipo A', false, 1);

-- Inserts para la tabla Condicion_Persona
INSERT INTO Condicion_Persona (cuil, numeroDePaciente, codigoDeCondicion, fecha) 
VALUES (20000000003, 3, 1, '2001-01-01'),(20000000003, 3, 5, '1968-08-10'),(20000000004, 4, 4, '2022-02-02'),(20000000005, 5, 3, '2022-03-03');

-- Inserts para la tabla Persona_EfectoAdverso
INSERT INTO Persona_EfectoAdverso (codigoEfecto, cuil, numeroDePaciente, fechaHora) 
VALUES (1, 20000000006, 6, '2023-01-01 12:00:00'),(3, 20000000006, 6, '2023-01-01 10:00:00'),
(2, 20000000003, 3, '2023-02-02 11:00:00'),(3, 20000000003, 3, '2023-03-03 12:00:00'),
(2, 20000000004, 4, '2023-03-02 11:30:00'), (3, 20000000005, 5, '2023-06-01 12:00:00'),
(1, 20000000007, 7, '2023-05-31 20:00:00');

-- Inserts para la tabla Persona_Tratamiento 
INSERT INTO Persona_Tratamiento (codigoTratamiento, identificador, cuil, numeroDePaciente) 
VALUES (1, 1, 20000000003, 3),(1, 2, 20000000004, 4),(1, 3, 20000000005, 5), (1, 4, 20000000006, 6),
(2, 1, 20000000003, 3),(2, 2, 20000000005, 5),(3, 1, 20000000004, 4),(1, 4, 20000000005, 5);

INSERT INTO Persona_Tratamiento (codigoTratamiento, identificador, cuil, numeroDePaciente, relacion) 
VALUES (4, 1, 20000000005, 5, 'Madre'),(4, 1, 20000000007, 7, 'Hijo/a');

-- Inserts para la tabla Contraindicacion 
INSERT INTO Contraindicacion (codigoTratamiento, codigoCondicion, comprobado) 
VALUES (1, 1, true),(2, 2, false),(3, 3, true);

-- Inserts para la tabla Tratamiento_CompuestoFarmacologico 
INSERT INTO Tratamiento_CompuestoFarmacologico (codigoTratamiento, identificador, codigoCompuesto) 
VALUES (1, 1, 123456),(1, 2, 123456),(2, 1, 789012);

-- Inserts para la tabla ComposicionCompuestoFarmacologico
INSERT INTO ComposicionCompuestoFarmacologico (codigoCompuesto, codigoFarmaco, cantidadEnMiligramos) 
VALUES (123456, 1, 10),(789012, 2, 1),(989012, 1, 8);

-- Inserts para la tabla Profesional_Especialidad 
INSERT INTO Profesional_Especialidad (cuil, numeroDePaciente, codigoEspecialidad) 
VALUES (20000000001, 1, 1),(20000000001, 1, 3),(20000000002, 2, 2), (20000000002, 2, 4);

-- Inserts para la tabla RangoEtario
INSERT INTO RangoEtario (valor, edadMinima, edadMaxima)
values('0 Años', 0, 0), ('1-5 Años', 1, 5), ('6-12 Años', 6, 12), ('13-17 Años', 13, 17), ('18-25 Años', 18, 25),
('26-40 Años', 26, 40), ('41 Años', 41, 50), ('51-70 Años', 51, 70), ('71-90 Años', 71, 90), ('+90 Años', 90, 255);

-- Consultas


-- • Detectar qué antecedentes de salud de las personas deberían ser tenidos en cuenta antes de aplicar un tratamiento.
select CT.descripcion as Tratamiento, C.descripcion as CondicionDeContraindicacion
from CodigoTratamiento CT join Contraindicacion CI on CT.codigo = CI.codigoTratamiento
	 join Condicion C on C.codigo = CI.codigoCondicion;

-- • Detectar qué efectos adversos se producen luego de un mismo tratamiento y en qué cantidad o porcentaje.
select PT.codigoTratamiento, PE.codigoEfecto, count(*)
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
group by PT.codigoTratamiento, PE.codigoEfecto;
   
   
-- I. Top 10 de tratamientos con más de 10 efectos adversos.
select PT.codigoTratamiento, count(distinct PE.codigoEfecto) as cantidadDeEfectosAdversos
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
group by PT.codigoTratamiento
having cantidadDeEfectosAdversos > 10
order by cantidadDeEfectosAdversos desc limit 10;


-- II. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el diagnóstico.
select count(distinct cuil, numeroDePaciente) as cantidadDePacientesConUnaPruebaDiagnosticaFalsa
from Persona_Tratamiento PT
where exists (select 1
			  from PracticaDiagnostica PD
              where PT.codigoTratamiento = PD.codigoTratamiento and PT.identificador = PD.identificador
              and PD.seConfirmo = false);
      
      
-- III. ¿Cuántas personas ha habido que hayan tenido la mayor cantidad de efectos adversos de algún tratamiento de vacunación?
select count(distinct cuil, numeroDePaciente) as cantidadDePacientesConLaMayorCantidadDeEfectosAdversosEnUnaVacunacion
from (select PT2.codigoTratamiento, PT2.cuil, PT2.numeroDePaciente, count(distinct PE.codigoEfecto) as cantidadDeEfectosAdversos
	  from Persona_Tratamiento PT2 join Tratamiento T on PT2.codigoTratamiento = T.codigoTratamiento and PT2.identificador = T.identificador 
	  	   join Persona_EfectoAdverso PE on PT2.cuil = PE.cuil and PT2.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
	  group by PT2.codigoTratamiento, PT2.cuil, PT2.numeroDePaciente
	  having cantidadDeEfectosAdversos = (select max(A.cantidadDeEfectosAdversos)
										  from (select count(distinct PE.codigoEfecto) as cantidadDeEfectosAdversos
										  from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
											   join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
										  where PT2.codigoTratamiento = PT.codigoTratamiento and PT.codigoTratamiento in (select distinct TC.codigoTratamiento      
																														  from Tratamiento_CompuestoFarmacologico TC 
																														  join CompuestoFarmacologico CF on TC.codigoCompuesto = CF.codigoDeBarras
																														  join FormaDeAdministracion FA on FA.codigo = CF.codigoFormaAdministracion
																														  where FA.descripcion like 'Vacuna')
										  group by PT.codigoTratamiento, PT.cuil, PT.numeroDePaciente) as A)) as B;


-- IV. ¿Cuántas muertes ocurrieron relacionadas con vacunas, agrupando por vacuna, durante los años 2021 al 2023?
select PT.codigoTratamiento, count(*) as cantidadDeMuertes
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
where PE.codigoEfecto = (select EA.codigo
						 from EfectoAdverso EA join GravedadDeEfecto GE on EA.codigoGravedad = GE.codigo
						 where GE.descripcion like 'Muerte')
      and PT.codigoTratamiento in (select TC.codigoTratamiento      
								  from Tratamiento_CompuestoFarmacologico TC 
								  join CompuestoFarmacologico CF on TC.codigoCompuesto = CF.codigoDeBarras
								  join FormaDeAdministracion FA on FA.codigo = CF.codigoFormaAdministracion
								  where FA.descripcion like 'Vacuna')  
	  and PE.fechaHora between '2020-12-31' and '2024-01-01'
group by PT.codigoTratamiento;


-- V. ¿Cuántas muertes de recién nacidos se pueden relacionar a medicamentos administrados a la madre? 
select count(*) as muertesDeRecienNacidosConPosibleRelacionAMedicacionMaterna
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
     join CodigoTratamiento CT on CT.codigo = T.codigoTratamiento 
where PE.codigoEfecto = (select EA.codigo
						 from EfectoAdverso EA join GravedadDeEfecto GE on EA.codigoGravedad = GE.codigo
						 where GE.descripcion like 'Muerte')
						 and CT.descripcion like 'Parto%'
						 and PT.relacion like 'Hijo/a'
						 and exists (select 1
									 from Persona_Tratamiento PT2
									 where PT.codigoTratamiento = PT2.codigoTratamiento 
										 and PT.identificador = PT2.identificador
										 and PT2.relacion like 'Madre'
										 and (PT2.cuil, PT2.numeroDePaciente) in (select distinct cuil, numeroDePaciente
																				  from Persona_Tratamiento PT3
																				  where PT3.codigoTratamiento in (select distinct TC.codigoTratamiento      
																												  from Tratamiento_CompuestoFarmacologico TC 
																												  join CompuestoFarmacologico CF on TC.codigoCompuesto = CF.codigoDeBarras
																												  join FormaDeAdministracion FA on FA.codigo = CF.codigoFormaAdministracion
																												  where FA.descripcion like 'Medicamento')));
                                                                                                                  

-- VI. Formulen una consulta que permita a un profesional médico descartar un
-- tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
-- guardarían para realizar esta comparación? Incluirla en el modelo completo.

-- Consulta: Traer el efecto esperado de un tratamiento y posible efectos adversos del mismo en niños
select distinct CT.descripcion as Tratamiento, CT.efectoEsperado, EA.descripcion as posibleEfectoAdverso
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
     join CodigoTratamiento CT on CT.codigo = PT.codigoTratamiento
     left join EfectoAdverso EA on EA.codigo = PE.codigoEfecto
where (PT.cuil, PT.numeroDePaciente) in (select P.cuil, P.numeroDePaciente
										 from Persona P join Persona_Tratamiento PT2 on P.cuil = PT.cuil  and P.numeroDePaciente = PT2.numeroDePaciente
											  join Tratamiento T on T.codigoTratamiento = PT2.codigoTratamiento and T.identificador = PT2.identificador
										 where PT.codigoTratamiento = PT2.codigoTratamiento and PT.identificador = PT2.identificador
											  and 12 >= (year(T.fechaHora) - year(P.fechaDeNacimiento)));
    
    
    
-- VII. Mostrar todos los tratamientos de bajo riesgo practicados a personas con al menos 2
-- (dos) patologías preexistentes y que sean adultos mayores.
select CT.descripcion as Tratamiento
from Persona_Tratamiento PT join CodigoTratamiento CT on PT.codigoTratamiento = CT.codigo 
where CT.invasivo = false 
	  and (PT.cuil, PT.numeroDePaciente) in (select P.cuil, P.numeroDePaciente
											 from Persona P join Persona_Tratamiento PT2 on P.cuil = PT.cuil  and P.numeroDePaciente = PT2.numeroDePaciente
												  join Tratamiento T on T.codigoTratamiento = PT2.codigoTratamiento and T.identificador = PT2.identificador
											 where PT.codigoTratamiento = PT2.codigoTratamiento and PT.identificador = PT2.identificador
												  and 60 <= (year(CURRENT_TIMESTAMP) - year(P.fechaDeNacimiento))
                                                  and 2 <= (select count(*) as cantidadDeCondicionesPreexistentes
															from Condicion_Persona CP 
															where CP.cuil = PT.cuil and CP.numeroDePaciente = PT.numeroDePaciente
															group by CP.cuil, CP.numeroDePaciente));


-- VIII. Formular una consulta que Uds. Le harían a la app para saber si realizarse un
-- tratamiento.

-- Consulta: Seleccionar la descripcion de los posible efectos adversos y contraindicaciones de un tratamiento
select distinct CT.descripcion as Tratamiento, EA.descripcion as EfectoAdverso, GE.descripcion as GravedadDeEfecto 
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
     join CodigoTratamiento CT on CT.codigo = T.codigoTratamiento
     join EfectoAdverso EA on EA.codigo = PE.codigoEfecto
     join GravedadDeEfecto GE on GE.codigo = EA.codigoGravedad;

-- Consulta: Seleccionar los medicos que realizaron Tratamientos con efectos adversos severos o mortales
select CT.descripcion as Tratamiento, P.nombre, P.apellido 
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
	 join CodigoTratamiento CT on CT.codigo = T.codigoTratamiento
     join Persona P on P.cuil = T.cuilProfesional and P.numeroDePaciente = T.numeroDePacienteProfesional;


-- IX. Destacar aquellos tratamientos letales, por causar efectos severos, por rango etario,
-- considerando 0 años, 1-5 años, 6-12 años, 13-17 años, 18 a 25 años, 26-40 años, 41-
-- 50 años, 51-70 años, 71-90 años, 91 o más años.
select PT.codigoTratamiento, RE.valor as rangoEtario
from Persona_Tratamiento PT join Tratamiento T on PT.codigoTratamiento = T.codigoTratamiento and PT.identificador = T.identificador 
	 join Persona_EfectoAdverso PE on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > T.fechaHora
     join EfectoAdverso EA on PE.codigoEfecto = EA.codigo
     join GravedadDeEfecto GE on GE.codigo = EA.codigoGravedad
     join Persona P on P.cuil = PT.cuil and P.numeroDePaciente = PT.numeroDePaciente
     join RangoEtario RE on (year(T.fechaHora) - year(P.fechaDeNacimiento)) between RE.edadMinima and RE.edadMaxima
where (GE.descripcion like 'Severo' or GE.descripcion like 'Muerte');
