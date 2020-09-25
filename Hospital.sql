
create database hospital;


use hospital;

create table TBPaciente(numero_paciente char(9), nome varchar(70),
		rg char(9),
		cpf char(11),
        rua varchar(50),
		numero varchar(6),
		complemento varchar(10),
		Cep char(8),
        primary key (numero_paciente));
        
create table TBTelefone(numero_paciente char(9),
		telefone char(9),foreign key(numero_paciente) references TBPaciente(numero_paciente));
        
create table TBConvenio(cod_convenio char(3),primary key(cod_convenio),nome_convenio varchar(30));

create table TBmedico(CRM char(6),
				UF char(2),
				nome varchar(70),
				rg char(9),
				cpf char(11),
                cod_convenio char(3),
				foreign key(cod_convenio) references TBConvenio(cod_convenio),
                primary key(CRM,UF));
 
 create table TBmedico_especialidade(
    cod_especialidade char(10),
	desc_especialidade varchar(20),
    CRM char(6),
    foreign key(CRM) references TBmedico(CRM),
    primary key(cod_especialidade));
    
create table TBMedicamento(codigo_medicamento char(10),primary key(codigo_medicamento),descricao_medicamento varchar(25));

create table TBConsulta(
	numero_paciente char(9),
	foreign key(numero_paciente) references TBPaciente(numero_paciente),
    UF char(2),
	CRM char(6),
    foreign key(CRM,UF) references TBmedico(CRM,UF),
	dia_consulta date,
    hora_consulta time,
    primary key(dia_consulta));
    
create table TBConsulta_exames(numero_paciente char(9),
				CRM char(6),
                dia_consulta date,
				codigo_exame char(3),
                primary key(codigo_exame),
                foreign key(dia_consulta) references TBConsulta(dia_consulta),
                foreign key(CRM) references TBmedico(CRM),
                foreign key(numero_paciente) references TBPaciente(numero_paciente));

create table TBExames(codigo_exame char(3),foreign key(codigo_exame) references TBConsulta_exames(codigo_exame), descricao_exame varchar(50));


insert into TBPaciente values(100,'joao',098765431,19283745821,'rua das ruas',52,'ap41',80730360);
insert into TBPaciente values(101,'maria',098765432,19283745822,'rua das estradas',53,'ap42',80730361);
insert into TBPaciente values(102,'carlos',098765433,19283745823,'rua dos apartamentos',54,'ap43',80730362); 
  
insert into TBTelefone values(100,098765671);
insert into TBTelefone values(101,098765672);
insert into TBTelefone values(102,098765673);

insert into TBConvenio values(11,'Amil');
insert into TBConvenio values(12,'Unimed');  
               
                
insert into TBmedico values(109061,'pr','antonella',627182811,0987654362,11);
insert into TBmedico values(109062,'sp','antonio',627182812,1090621341,12);
insert into TBmedico values(109063,'go','marcelo',627182812,1090633415,11);
              
insert into TBmedico_especialidade values(0987654362,'cirurgiao plastico',109061);
insert into TBmedico_especialidade values(1090621341,'cirurgiao estomago',109062);
insert into TBmedico_especialidade values(1090633415,'cirurgiao esofago',109063);              
              
insert into TBMedicamento values(5678987654,'paracetamol');
insert into TBMedicamento values(5678987655,'cloroquina');
insert into TBMedicamento values(5678987656,'ritalina');

insert into TBConsulta values(100,'pr',109061,'2010-01-10', '09:10:01');
insert into TBConsulta values(101,'sp',109062,'2019-12-13', '09:40:10');
insert into TBConsulta values(102,'go',109063,'2019-11-29', '11:10:40');

insert into TBConsulta_exames values(100,109061,'2010-01-10',211);
insert into TBConsulta_exames values(101,109061,'2019-12-13',212);
insert into TBConsulta_exames values(102,109061,'2019-11-29',213);

insert into TBExames values(211,'ecografia');
insert into TBExames values(212,'resonancia');
insert into TBExames values(213,'tomografia');


SELECT TBmedico.nome, TBConvenio.nome_convenio
FROM TBConvenio, TBmedico
WHERE TBConvenio.nome_convenio = 'Unimed' and TBmedico.cod_convenio = TBConvenio.cod_convenio or
    TBConvenio.nome_convenio = 'Amil' and TBmedico.cod_convenio = TBConvenio.cod_convenio;
    
SELECT *
FROM TBConsulta_exames
WHERE DATE(dia_consulta) = '2019-11-29';



SELECT TBConvenio.nome_convenio, TBMedico.nome
FROM TBConvenio
LEFT JOIN TBMedico ON TBMedico.cod_convenio = TBConvenio.cod_convenio and TBConvenio.nome_convenio = ('Unimed'or'Amil');



SELECT  TBmedico_especialidade.desc_especialidade, COUNT(TBmedico.CRM)
FROM TBmedico
left JOIN TBmedico_especialidade ON TBmedico.CRM = TBmedico_especialidade.CRM
GROUP BY TBmedico_especialidade.desc_especialidade;



SELECT MAX(TBExames.descricao_exame)
FROM TBExames
LEFT JOIN TBConsulta_exames ON TBExames.codigo_exame = TBConsulta_exames.codigo_exame;



SELECT TBmedico.nome, COUNT(TBConsulta.dia_consulta)
FROM TBmedico
LEFT JOIN TBConsulta ON TBmedico.CRM = TBConsulta.CRM
WHERE year(TBConsulta.dia_consulta) = 2019
GROUP BY TBmedico.nome;



SELECT TBConvenio.nome_convenio
FROM TBConvenio
LEFT JOIN TBmedico
    ON TBMedico.cod_convenio = TBConvenio.cod_convenio
LEFT JOIN TBConsulta 
    ON TBConsulta.CRM = TBmedico.CRM
WHERE YEAR(TBConsulta.dia_consulta) != '2019';


SELECT TBmedico.nome
FROM TBmedico
Inner JOIN TBConsulta ON TBmedico.CRM = TBConsulta.CRM
WHERE year (TBConsulta.dia_consulta) != 2020 and month (TBConsulta.dia_consulta) != 5;