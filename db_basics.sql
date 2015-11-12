-- if you already have a database called 'Basics' then read ahead, don't just hit F5!

-- (re)create and use a database
if exists (select * from sysdatabases where Name = 'Basics')
	drop database Basics;
create database Basics;
use Basics;

-- create a table
create table RNA
(
	RnaId int identity(1,1) primary key,
	Name varchar(50) not null,
	Length int not null,
	StartCodon int not null,
	Purpose varchar(255) null
);

-- create data
insert RNA (Name, Length, StartCodon, Purpose) 
values ('hsa-mir-1302-2', 23, 35351, 'Regulates something?'),
       ('U34', 28, 1, 'Does something else?'),
       ('hsa-mir-302c', 22, 353, 'No idea, let''s leave this blank in future.'),
       ('HBII-436', 23, 42545, null);

-- retrieve data
select * from RNA where Name like 'hsa%';

-- update data
update RNA set Purpose = null where Name = 'U34';
select * from RNA where Name = 'U34';

-- delete data
delete from RNA where Name = 'U34';
select * from RNA;

-- slicing and dicing data
select distinct Length from RNA;
select Length, count(*) as [Count] from RNA group by Length;
select * from RNA order by StartCodon;

-- another table
create table Chromosomes
(
	ChromosomeId int identity(1,1) primary key,
	Name varchar(50)
);

-- show the data after import
select * from Chromosomes;

-- add a link field
alter table RNA add ChromosomeId int not null default(1);

-- create the foreign key
alter table RNA add constraint FK_RNA_Chromosomes
	foreign key (ChromosomeId)
	references Chromosomes (ChromosomeId)
	on delete cascade;

-- RNA chromosomes
select * from RNA;

-- chromosome RNAs
select c.Name as [Chromosome name], r.Name as [RNA name]
from   Chromosomes c
       inner join RNA r on c.ChromosomeId = r.ChromosomeId

-- chromosome RNA counts
select c.Name as [Chromosome name], count(*) as [RNA count]
from   Chromosomes c
       inner join RNA r on c.ChromosomeId = r.ChromosomeId
group by c.Name;

-- chromosome RNAs
select c.Name as [Chromosome name], r.Name as [RNA name]
from   Chromosomes c
       left outer join RNA r on c.ChromosomeId = r.ChromosomeId

-- add some more RNAs
insert RNA (Name, Length, StartCodon, Purpose, ChromosomeId) 
values ('U10', 23, 565, null, 2),
       ('U11', 23, 565, null, 2),
       ('U12', 23, 565, null, 2),
       ('Xist', 22, 4453, 'Inactivates one X chromosome in females', 23),
       ('T', 23, 7987, null, 24);
select * from RNA;

-- RNA chromosome names
select r.Name as [RNA name], c.Name as [Chromosome name]
from   Chromosomes c
       inner join RNA r on c.ChromosomeId = r.ChromosomeId

-- RNA length analysis
select Length, count(*) as [Count] from RNA group by Length;