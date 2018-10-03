create database proiect;
use proiect;
#drop database proiect;

# 6 tabele:produs,categorie,sucursala,furnizor,client,factura

create table if not exists produs(
id_produs tinyint not null auto_increment primary key,
nume varchar (50) not null,
pret double not null,
pe_stoc int default 0

);

create table if not exists categorie(
id_categorie tinyint not null auto_increment primary key,
nume varchar(50) not null

);
create table if not exists sucursala(
id_sucursala tinyint not null auto_increment primary key,
denumire varchar(50)

);

create table if not exists furnizor(
id_furnizor tinyint not null auto_increment primary key,
nume varchar(50) not null,
id_sucursala tinyint,
foreign key(id_sucursala) references sucursala(id_sucursala)

);

create table if not exists client(
id_client tinyint not null auto_increment primary key,
nume varchar(50) not null,
prenume varchar(50) not null,
sexul enum('m','f','nespecificat'),
adresa varchar(200) not null,
cnp varchar(13) not null

);

create table if not exists factura(
id_factura tinyint not null auto_increment primary key

);

#ALTER TABLE 
alter table categorie
change  nume denumire varchar(50) not null;

alter table client
add data_nasterii date not null;

alter table produs
add id_furnizor tinyint not null;

alter table produs
add constraint id_furnizor_fk
foreign key(id_furnizor) references furnizor(id_furnizor);

alter table factura
add id_client tinyint not null;

alter table factura
add id_produs tinyint not null;

alter table factura
add constraint id_produs_fk
foreign key(id_produs) references produs(id_produs);

alter table factura
add constraint id_client_fk
foreign key(id_client) references client(id_client);

alter table sucursala
add numar_angajati int not null;

alter table sucursala
drop column numar_angajati;

alter table produs
add id_categorie tinyint not null;

alter table produs
add constraint id_categorie_fk
foreign key (id_categorie) references categorie(id_categorie);



#--------------------------------------------------------2 ACTUALIZAREA DATELOR
#INSERT

insert into  sucursala values(null,'Bucuresti'),(null,'Timisoara'),
(null,'Brasov'),(null,'Iasi'),(null,'Targoviste'),
(null,'Suceava'),(null,'Constanta'),
(null,'Cluj'),(null,'Ploiesti'),(null,'Pitesti');

insert into furnizor values(null,'Samsung',1),(null,'Lenovo',2),(null,'Philips',3),
(null,'Bic',4),(null,'Milka',1),(null,'Oreo',5),
(null,'Nestle',6),(null,'Cola',7),(null,'Zuzu',8),(null,'Pepsi',9),(null,'Borsec',10),
(null,'Alexandrion',9),(null,'Farmasi',2),(null,'H&M',5);

insert into categorie values(null,'gadget'),(null,'electronice'),(null,'aparatura de bucatarie'),
(null,'birotica'),(null,'dulciuri'),(null,'alimente'),(null,'bauturi carbogazoase'),
(null,'alcool'),(null,'ingrijire'),(null,'haine');

insert into client values(null,'Popescu','Ion','m','Bucuresti,Sectorul 1','123456789101','1980-3-19'),
(null,'Voicu','Ana-Maria','f','Targoviste','123456789102','1960-4-20'),
(null,'Pop','Ionela','f','Bucuresti,Sectorul 2','123456789103','1996-5-10'),
(null,'Dita','Maria','f','Chitila','123456789104','1970-6-7'),
(null,'Ion','Andrei','m','Ploiesti','123456789105','1990-8-30'),
(null,'Dinu','Cristian','m','Baneasa','123456789106','1956-1-23'),
(null,'Popescu','Marieta','f','Bucuresti,Sectorul 6','123456789107','1972-3-1'),
(null,'Voicila','Alexandra','f','Bucuresti,Sectorul 4','123456789108','1998-6-10');
insert into client values(null,'Popescu','Marian','m','Bucuresti,Sercorul 1','123456789109','1979-9-10'),
(null,'Georgescu','Anca','f','Targoviste','13456789111','1989-2-18'),
(null,'Petrescu','Aniela','f','Pitesti','123456789112','1997-8-19');

insert into produs values(null,'ciocolata',5.2,10,5,5),
(null,'ciocolata',4.5,3,7,5),
(null,'biscuiti',3.0,12,6,5),
(null,'suc',2.5,10,8,7),
(null,'suc',3.0,11,10,7),
(null,'lapte',4.9,5,9,6),
(null,'vin',20.0,3,12,8),
(null,'caiet',2.4,6,4,4),
(null,'pix',2.3,10,4,4),
(null,'tableta',1050.0,1,1,2),
(null,'telefon',1600.0,2,1,2),
(null,'bluza',25.0,4,14,10);

insert into factura values(null,1,1),(null,1,2),(null,2,4),(null,3,5),
(null,4,3),(null,5,6),(null,6,7),
(null,6,8),(null,7,1),(null,7,3),
(null,8,11),(null,8,12),(null,7,10),(null,3,9);

insert into factura values(null,1,10),(null,9,9),(null,5,11);



#UPDATE

update client
set nume='Ionescu'
where cnp='123456789112';

update client
set adresa='Bucuresti,Sector 1'
where cnp='13456789111';

#Schimbarea furnizorului pentru telefon..din Samsung in Lenovo
update produs
set id_furnizor = 2
where id_produs=11;


#DELETE

delete from factura
where id_client=10;

delete from factura
where id_client=9;

delete from factura
where id_client=4;

#-------------------------------------------4 INTEROGARI VARIATE CU SELECT

#afisarea produselor din categoria dulciuri=5
select * from produs
where id_categorie=5;

#afisarea clientilor de sex masculin
select count(*) from client
where sexul='m';

#afisarea numelui si prenumelui clientilor cu varsta mai mare de 30 de ani
select nume,prenume from client
where (year(curdate())-year(data_nasterii))>30;


#afisarea clientilor cu numele terminat in 'escu';
select * from client
where nume like '%escu';

#afisarea produselor de pe stoc si categoria din care fac parte INNER JOIN

select p.nume,p.pret,p.pe_stoc,c.denumire from produs as p inner join categorie as c
where c.id_categorie=p.id_categorie
and p.pe_stoc>0
ORDER BY nume;


#afisarea produselor cumparate de clientul cu cnp 123456789101 INNER JOIN 

select c.nume,c.prenume,p.nume from client as c inner join factura as f inner join produs as p
where c.id_client=f.id_client and f.id_produs=p.id_produs
and c.cnp='123456789101';

#afisare categoriile pentru care nu exista produse OUTER JOIN

select denumire from categorie as c left join produs as p on
c.id_categorie=p.id_categorie
where id_produs is null;

#afisare categoria din care face parte produsul cu pretul cel mai mare SUBSELECT 1
#pas 1 :produsul cu pretul cel mai mare

select id_categorie from produs
where pret=(select max(pret) from produs);

#pasul 2
select denumire from categorie 
where id_categorie=(select id_categorie from produs
where pret=(select max(pret) from produs));


#afisarea produselor care au prtul mai mic decat pretul mediu SUBSELECT 2
#pasul 1
select avg(pret) as pret_mediu from produs;
#pasul 2
select nume,pret,id_categorie from produs 
where pret<(select avg(pret) from produs);


#afisarea furnizorilor care au sucursala in Bucuresti SUBSELECT 3
#pas 1
select id_sucursala from sucursala where denumire='Bucuresti';
#pas 2
select nume from furnizor where id_sucursala=(select id_sucursala from sucursala where denumire='Bucuresti');


#-----------------------------------------------5 VIEW

# view pentru a afisa toate produsele din categoria dulciuri
CREATE OR REPLACE VIEW afisare_dulciuri AS
select p.nume,c.denumire from produs as p inner join categorie as c
where p.id_categorie =c.id_categorie and denumire='dulciuri';


select * from afisare_dulciuri;

#-------------------------------------------------6 FUNCTII

#determina daca pretul unui produs este mai mare decat pretul mediu al tuturor produselor Functia 1
delimiter //
create function compara_pret(id_prod tinyint) returns varchar(200)
begin
declare pret_mediu double;
declare pret_produs double;
declare mesaj varchar(200);
select avg(pret) into pret_mediu from produs;
select pret into pret_produs from produs
where id_produs=id_prod;
if pret_produs>pret_mediu then
set mesaj=concat_ws(' ','Produsul cu id-ul:',id_prod,'este mai scump decat pretul mediu.');
elseif pret_produs<pret_mediu then
set mesaj=concat_ws(' ','Produsul cu id-ul:',id_prod,'este mai ieftin decat pretul mediu.');
else
set mesaj=concat_ws(' ','Produsul cu id-ul:',id_prod,'are acelasi pret cu pretul mediu.');
end if;
return mesaj;
end;
//
delimiter ;

select compara_pret(3);

#afiseaza denumirea celui mai scump produs Functie 2
delimiter //
create function cel_mai_scump_produs() returns varchar(50)
begin
declare v_nume varchar(50);
select nume into v_nume from produs
where pret=(select max(pret) from produs);
return v_nume;
end;
//
delimiter ;

select cel_mai_scump_produs();

#afisare lista cu id-urile clientilor care au cumparat produse care provin de la furnizorul X Functie 3
delimiter //
create function lista_clienti_furnizor(id_f tinyint) returns varchar(50)
begin
declare rezultat varchar(50);
select group_concat(c.id_client) into rezultat 
from client as c inner join factura as f inner join produs as p inner join furnizor as fu
where c.id_client=f.id_client and f.id_produs=p.id_produs and p.id_furnizor=fu.id_furnizor
and fu.id_furnizor=id_f;
return rezultat;
end;
//
delimiter ;


select lista_clienti_furnizor(2);

  
#-------------------------------------------------7 PROCEDURI

#afiseaza toate produsele cu un pret mai mic decat cel al produsului dat ca si parametru Procedura 1

delimiter //
create procedure produse_mai_ieftine(IN id_prod tinyint) 
begin
select nume,pret from produs
where pret<(select pret from produs where id_produs=id_prod);
end;
//
delimiter ;

call produse_mai_ieftine(1);

#intrare: id produs ...iesire: denumire,pret,furnizor Procedura 2

delimiter //
create procedure detalii_dupa_id(IN id_prod tinyint,OUT v_nume varchar(50),OUT v_pret double,OUT v_furnizor varchar(50))
begin
select p.nume,p.pret,f.nume into v_nume,v_pret,v_furnizor 
from produs as p inner join furnizor as f
where p.id_furnizor=f.id_furnizor
and p.id_produs=id_prod;
end;
//
delimiter ;

set @id=6;
call detalii_dupa_id(@id,@n,@p,@f);
select @id,@n,@p,@f;

#introducere id si afisare produse cumparate de clientul respectiv Procedura 3
delimiter //
create procedure detalii_client(IN id_c tinyint)
begin
select c.nume,p.nume,p.pret from client as c inner join factura as f inner join produs as p
where c.id_client=f.id_client and f.id_produs=p.id_produs and c.id_client=id_c;
end;
//
delimiter ;

call detalii_client(8);

#--------------------------------------------------8 CURSORI
#functie care contine un cursor..creeaza o lista cu toate produsele cu pretul>pragul X Cursorul 1

delimiter //
create function pret_mai_mare_decat(x double) returns varchar(400)
begin
declare lista varchar(400);
declare v_nume_produs varchar(50);
declare ok tinyint default 1;
declare c cursor for
select nume from produs
where pret>x;
declare continue handler for not found set ok=0;
open c;
produse:loop
fetch c into v_nume_produs;
if ok=1 then
set lista=concat_ws(',',lista,v_nume_produs);
else
leave produse;
end if;
end loop;
close c;
return lista;
end;
//
delimiter ;

select pret_mai_mare_decat(15);

#procedura care insereaza toate produsele care au pretul sub 100 de lei intr-o tabela noua-produse ieftine Cursorul 2
create table produse_ieftine(
id tinyint auto_increment not null primary key,
denumire varchar(50),
pret double
);

delimiter //
create procedure gaseste_produse_ieftine()
begin
declare v_nume varchar(50);
declare v_pret double;
declare ok tinyint default 1;

declare c cursor  for 
select nume,pret from produs
where pret<100;
declare continue handler for not found set ok=0;
open c;
produse_i:loop
fetch c into v_nume,v_pret;
if ok=1 then
insert into produse_ieftine values(null,v_nume,v_pret);
else 
leave produse_i;
end if;
end loop;
end;
//
delimiter ;

call gaseste_produse_ieftine();
select * from produse_ieftine;
/*drop table produse_ieftine;
drop procedure gaseste_produse_ieftine;*/

#afisaza clientii care au cumparat un anumit produs dat ca si paramentru Cursorul 3

delimiter //
create procedure afiseaza_clientii_care_cumpara(IN prod varchar(50),OUT lista varchar(50))
begin
declare v_nume varchar(50);
declare v_prenume varchar(50);
declare ok tinyint default 1;
declare c cursor for
select c.nume,c.prenume from client as c inner join factura as f inner join produs as p
where c.id_client=f.id_client and f.id_produs=p.id_produs
and p.nume=prod;
declare continue handler for not found set ok=0;
open c;
prod:loop
fetch c into v_nume,v_prenume;
if ok=1 then
set lista=concat_ws(',',lista,v_nume,v_prenume);
else
leave prod;
end if;
end loop;
close c;
end;
//
delimiter ;

#drop procedure afiseaza_clientii_care_cumpara;

set @lista='';
call afiseaza_clientii_care_cumpara('ciocolata',@lista);
select @lista;


#--------------------------------------------------9 TRIGGERI

#inainte de insert aplica lower() pe denumirea produsului Trigger 1
delimiter //
create trigger before_insert_produs BEFORE INSERT  on produs for each row
begin
set new.nume=lower(new.nume);
end;
//
delimiter ;

#drop trigger before_insert_produs;
insert into produs values(null,'TEQUILA',3.5,5,12,8);
select * from produs where id_produs=(select max(id_produs) from produs);

#dupa fiecare inserare de produs sa se introduca o noua inregistrare in produs ieftin daca acesta are pretul<100 Trigger 2

delimiter //
create trigger after_insert_produs AFTER INSERT on produs for each row
begin
IF new.pret < 100 then
insert into produse_ieftine values(null,new.nume,new.pret);
end if;
end;
//
delimiter ;
#drop trigger after_insert_produs;

insert into produs values(null,'BISCUITI CU LAPTE',2.4,30,5,5),(null,'SMARTPHONE',1700.0,1,1,1);
select * from produse_ieftine;


#de fiecare data cand se insereaza un client nou daca acesta nu are resedinta in Bucuresti se insereaza datele lui in tabela clienti din provincie Trigger 3
create table clienti_provincie(
id tinyint not null auto_increment primary key,
id_client tinyint,
nume varchar(50),
adresa varchar(50),
foreign key(id_client) references client(id_client)

);

delimiter //
create trigger before_insert_client AFTER INSERT on client for each row
begin
if new.adresa != 'Bucuresti%'then
insert into clienti_provincie values(null,new.id_client,concat_ws('_',new.nume,new.prenume),new.adresa);
end if;
end;
//
delimiter ;


insert into client values(null,'Tomescu','Mihai','m','Ploiesti','123456299189','1997-03-06');
select * from clienti_provincie;

#-----------------------------------------THE END :)-------------------------------------------------



