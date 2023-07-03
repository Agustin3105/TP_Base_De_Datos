drop database if exists app;
create database if not exists app;
use app;

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

create table Antecedente(
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

create table Fármaco(
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
invasivo boolean not null
);

create table Tratamiento(
codigoTratamiento int not null,
identificador int not null,
fechaHora datetime not null,
efectoEsperado varchar(50),
codigoCentroDeSalud int,
cuilProfesional bigint not null,
numeroPacienteProfesional bigint not null,

constraint foreign key (cuilProfesional, numeroPacienteProfesional) references Profesional(cuil, numeroPaciente),
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

create table Persona(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null auto_increment,
constraint Persona_pk primary key (cuil, numeroDePaciente)
);

create table Profesional(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
nombre varchar(20) not null,
apellido varchar(20) not null,
celular int,
email varchar(50),
direccion varchar(50),
codigoPostal tinyint,
matriculaProvincial int unique,
matriculaNacional int unique,

constraint Profesional_pk primary key (cuil, numeroDePaciente),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente)
);

create table Antecedente_Persona(
cuil bigint unsigned not null,
numeroDePaciente bigint unsigned not null,
codigoDeAntecedente int not null,
fecha date,

constraint Antecedente_Persona_pk primary key (cuil, numeroDePaciente, codigoDeAntecedente)
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

constraint primary key Persona_Tratamiento_pk (codigoTratamiento, identificador, cuil, numeroDePaciente),
foreign key (codigoTratamiento, identificador) references Tratamiento(codigoTratamiento, identificador),
foreign key (cuil, numeroDePaciente) references Persona(cuil, numeroDePaciente)
);

create table Contraindicacion(
codigoTratamiento int not null,
codigoAntecedente int not null,
comprobado bool not null,

constraint Contraindicacion_pk primary key (codigoTratamiento, codigoAntecedente),
foreign key (codigoTratamiento) references Tratamiento(codigo),
foreign key (codigoAntecedente) references Antecedente(codigo)
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
numeroPaciente bigint unsigned not null, 
codigoEspecialidad int not null,

constraint Profesional_Especialidad_pk primary key (cuil, numeroPaciente, codigoEspecialidad),
foreign key (cuil, numeroPaciente) references Profesional(cuil, numeroPaciente),
foreign key (codigoEspecialidad) references Especialidad(codigo)
);

create table ComposicionCompuestoFarmacologico(
codigoCompuesto int not null, 
codigoFarmaco int not null, 
cantidadEnMiligramos int, 
constraint ComposicionCompuestoFarmacologico_pk primary key (codigoCompuesto, codigoFarmaco, cantidad),
foreign key (codigoCompuesto) references CompuestoFarmacologico(codigo),
foreign key (codigoFarmaco) references Farmaco(codigo)
);

-- Inserts para la tabla Persona
INSERT INTO Persona (cuil, numeroDePaciente, nombre, apellido, celular, email, direccion, codigoPostal) 
VALUES (20000000001, 1, 'Juan', 'Perez', 1132345678, 'correo1@example.com', 'Jose Marmol 21', 12345),
(20000000002, 2, 'Maria', 'Perez', 1145345678, 'correo2@example.com', 'Jose Juarez 21', 12345), 
(20000000003, 3, 'Norberto', 'Alpozo', 1189765432, 'correo3@example.com', 'San Pedro 2211', 54321),
(20000000004, 4,'Roberto', 'Alonso', 1198765432, 'correo4@example.com', 'San Pedro 2111', 54321),
(20000000005, 5, 'Lidia', 'Martinez', 1112765432, 'correo10@example.com', 'Rivadavia 2911', 1321),
(20000000006, 6, 'Marcos', 'Ayala', 1172365432, 'correo20@example.com', 'Belgrano 2211', 6721);

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
VALUES (1, 'Arritmia Cardiaca'),(2, 'Bulimia'),(3, 'Cancer');

-- Inserts para la tabla Antecedente
INSERT INTO Antecedente (codigo, descripcion, codigoDiagnostico) 
VALUES (1, 'Arritmia Tipo A', 1),(2, 'Arritmia Tipo B', 1),(3, 'Leucemia', 3),(4, 'Trastorno Alimenticio por Depresion', 2);

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
INSERT INTO Fármaco (descripcion) VALUES ('Ibuprofeno'),('Morfina'),('Vacunitaximina');

-- Inserts para la tabla CompuestoFarmacologico
INSERT INTO CompuestoFarmacologico (codigoDeBarras, fechaVencimiento, fabricante, numeroDeLote, partida, codigoOrigen, codigoFormaAdministracion)
VALUES (123456, '2023-12-31', 'Pfizer', 1, 1, 1, 1),(789012, '2024-06-30', 'PSK', 2, 2, 2, 2), (989012, '2027-02-30', 'Roemmers', 2, 2, 2, 2);

-- Inserts para la tabla CodigoTratamiento
INSERT INTO CodigoTratamiento (lugarDelCuerpo, descripcion, invasivo) 
VALUES ('Brazo', 'Vacuna Cobid-29', false),('Rodilla', 'Operacion de Meniscos', true),('Cuerpo Entero', 'Electrocardiograma', false);

-- Inserts para la tabla Tratamiento
INSERT INTO Tratamiento (codigoTratamiento, identificador, fechaHora, efectoEsperado, codigoCentroDeSalud, cuilProfesional, numeroPacienteProfesional)
VALUES (1, 1, '2023-10-05 09:00:00', 'Generacion de Anticuerpos', 1, 20000000001, 1), 
(1, 2, '2023-07-01 09:05:00', 'Generacion de Anticuerpos', 1, 20000000001, 1),
(1, 3, '2023-01-01 10:00:00', 'Reactivación del sistema inmune', 1, 20000000001, 1),
(2, 1, '2023-03-04 09:30:00', 'Relocación del Hueso', 1, 20000000002, 2),
(3, 1, '2023-11-23 14:30:00', 'Descubrir posible derrame', 2, 20000000002, 2);


-- Inserts para la tabla PracticaQuirurgica
INSERT INTO PracticaQuirurgica (codigoTratamiento, identificador, fueExitosa) VALUES (2, 1, true);


-- Inserts para la tabla PracticaDiagnostica
INSERT INTO PracticaDiagnostica (codigoTratamiento, identificador, diagnosticoPresuntivo, seConfirmo, codigoDiagnostico)
VALUES (3, 1, 'Arritmia Tipo A', true, 1);

-- Inserts para la tabla Antecedente_Persona
INSERT INTO Antecedente_Persona (cuil, numeroDePaciente, codigoDeAntecedente, fecha) 
VALUES (20000000003, 3, 1, '2022-01-01'),(20000000004, 4, 4, '2022-02-02'),(20000000005, 5, 3, '2022-03-03');

-- Inserts para la tabla Persona_EfectoAdverso
INSERT INTO Persona_EfectoAdverso (codigoEfecto, cuil, numeroDePaciente, fechaHora) 
VALUES (1, 20000000006, 6, '2022-01-01 10:00:00'),(2, 20000000002, 2, '2022-02-02 11:00:00'),(3, 20000000003, 3, '2022-03-03 12:00:00');

-- Inserts para la tabla Persona_Tratamiento 
INSERT INTO Persona_Tratamiento (codigoTratamiento, identificador, cuil, numeroDePaciente) 
VALUES (1, 1, 20000000003, 3),(1, 2, 20000000004, 4),(1, 3, 20000000005, 5), 
(2, 1, 20000000003, 3),(3, 1, 20000000004, 4);

-- Inserts para la tabla Contraindicacion 
INSERT INTO Contraindicacion (codigoTratamiento, codigoAntecedente, comprobado) 
VALUES (1, 1, true),(2, 2, false),(3, 3, true);

-- Inserts para la tabla Tratamiento_CompuestoFarmacologico 
INSERT INTO Tratamiento_CompuestoFarmacologico (codigoTratamiento, identificador, codigoCompuesto) 
VALUES (1, 1, 123456),(1, 2, 123456),(2, 1, 789012);

-- Inserts para la tabla ComposicionCompuestoFarmacologico
INSERT INTO ComposicionCompuestoFarmacologico (codigoCompuesto, codigoFarmaco, cantidadEnMiligramos) 
VALUES (123456, 1, 10),(789012, 2, 1),(989012, 1, 8);

-- Inserts para la tabla Profesional_Especialidad 
INSERT INTO Profesional_Especialidad (cuil, numeroPaciente, codigoEspecialidad) 
VALUES (20000000001, 1, 1),(20000000001, 1, 3),(20000000002, 2, 2), (20000000002, 2, 4);


-- Consultas

/*
• Conocer la frecuencia de ciertos eventos asociados a los tratamientos.
• Calcular la correlación de ciertos efectos adversos con distintos tratamientos.
• Conocer en qué medida la prescripción de los tratamientos empeora o mejora la
salud de las personas.
• Detectar qué antecedentes de salud de las personas deberían ser tenidos en cuenta
antes de aplicar un tratamiento.

i. Top 10 de tratamientos con más de 10 efectos adversos.
ii. Cantidad de personas con algún tratamiento diagnóstico que no haya confirmado el
diagnóstico.
iii. ¿Cuántas personas ha habido que hayan tenido la mayor cantidad de efectos
adversos de algún tratamiento de vacunación?
iv. ¿Cuántas muertes ocurrieron relacionadas con vacunas, agrupando por vacuna,
durante los años 2021 al 2023?
v. ¿Cuántas muertes de recién nacidos se pueden relacionar a medicamentos
administrados a la madre? Si el modelo realizado no permite contestar esta
pregunta, modificarlo para poder hacerlo.
vi. Formulen una consulta que permita a un profesional médico descartar un
tratamiento en niños por ser el riesgo mayor al beneficio. ¿Qué otra información
guardarían para realizar esta comparación? Incluirla en el modelo completo.
vii. Mostrar todos los tratamientos de bajo riesgo practicados a personas con al menos 2
(dos) patologías preexistentes y que sean adultos mayores.
viii. Formular una consulta que Uds. Le harían a la app para saber si realizarse un
tratamiento.
ix. Destacar aquellos tratamientos letales, por causar efectos severos, por rango etario,
considerando 0 años, 1-5 años, 6-12 años, 13-17 años, 18 a 25 años, 26-40 años, 41-
50 años, 51-70 años, 71-90 años, 91 o más años.*/

-- • Detectar qué efectos adversos se producen luego de un mismo tratamiento y en qué cantidad o porcentaje.

select Tratamiento.codigo, EfectoAdverso.codigo, count(*)
from Persona_Tratamiento PT join Persona_EfectoAdverso PE 
	 on PT.cuil = PE.cuil and PT.numeroDePaciente = PE.numeroDePaciente and PE.fechaHora > PT.fechaHora


