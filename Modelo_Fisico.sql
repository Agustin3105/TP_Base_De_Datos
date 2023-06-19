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
fecha date,
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
)

create table Tratamiento(
codigo int primary key not null auto_increment,
fecha date not null,
lugarDelCuerpo varchar(50) not null,
efectoEsperado varchar(50),
codigoCentroDeSalud int,
cuilProfesional bigint not null,
numeroPacienteProfesional bigint not null,
cuilPersona bigint not null,
numeroPacientePersona bigint not null,

constraint foreign key (cuilProfesional, numeroPacienteProfesional) references Profesional(cuil, numeroPaciente),
foreign key (cuilPersona, numeroPacientePersona) references Persona(cuil, numeroPaciente),
foreign key (codigoCentroDeSalud) references CentroDeSalud(codigo)
);

create table PracticaQuirurgica(
codigo int primary key not null,
fueExitosa bool,

constraint foreign key (codigo) references Tratamiento(codigo)
);

create table PracticaDiagnostica(
codigo int primary key not null,
diagnosticoPresuntivo varchar(50) not null,
seConfirmo bool not null,
codigoDiagnostico int, 

constraint foreign key (codigoDiagnostico) references Diagnostico(codigo)
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

create table Tratamiento_EfectoAdverso(
codigoTratamiento int not null,
codigoEfectoAdverso int not null,

constraint Tratamiento_EfectoAdverso_pk primary key (codigoTratamiento, codigoEfectoAdverso),
foreign key (codigoTratamiento) references Tratamiento(codigo),
foreign key (codigoEfectoAdverso) references EfectoAdverso(codigo)
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
codigoCompuesto int not null,

constraint Tratamiento_CompuestoFarmacologico_pk primary key (codigoTratamiento, codigoCompuesto),
foreign key (codigoTratamiento) references Tratamiento(codigo),
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

