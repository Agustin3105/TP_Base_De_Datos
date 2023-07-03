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

-- consultar posible entidad debil
create table CompuestoFarmacologico(
codigoDeBarras int primary key not null, 
fechaVencimiento date not null,
fabricante varchar(50) not null,
numeroDeLote int, 
partida int? -- consultar,
codigoOrigen int not null,
codigoFormaAdministracion int not null,

constraint foreign key (codigoOrigen) references OrigenDeCompuesto(codigo),
foreign key (codigoFormaAdministracion) references FormaDeAdministracion(codigo)
);

create table CodigoTratamiento(
codigo int primary key not null auto_increment,
lugarDelCuerpo varchar(50),
descripcion varchar(50) not null
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
cantidad int, 
constraint ComposicionCompuestoFarmacologico_pk primary key (codigoCompuesto, codigoFarmaco, cantidad),
foreign key (codigoCompuesto) references CompuestoFarmacologico(codigo),
foreign key (codigoFarmaco) references Faramaco(codigo)
);

EfectoAdverso-Diagnostico-Antecedente-Especialidad-FormaDeAdministracion-
OrigenDeCompuesto-Fármaco-CompuestoFarmacologico-Tratamiento-PracticaQuirurgica-PracticaDiagnostica-
Persona-Profesional-Antecedente_Persona-Tratamiento_EfectoAdverso-Contraindicacion-Tratamiento_CompuestoFarmacologico-
Profesional_Especialidad-ComposicionCompuestoFarmacologico

insert into CentroDeSalud (nombre, direccion)
values('Hospital Italiano','Perón 2987'), ('Hospital Argerich','Romero 173'), ('Hospital Garrahan','Martinez 987');

insert into GravedadDeEfecto (descripcion)
values ('Leve'), ('Moderado'), ('Grave'), ('Severo'), ('Muerto');




