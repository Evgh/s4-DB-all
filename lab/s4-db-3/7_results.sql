USE KASPER_UNIVER;
CREATE table RESULTS 
(
	ID int primary key identity(1,1),
	Student_Surname varchar(20),
	OOP real not null,
	DB real not null,
	Math real not null,
	Alter_value as (OOP+DB+Math)/3
)

INSERT into RESULTS values ('Касперович', 6, 6, 8), ('Lityagin', 9, 9, 6), ('Bozhko', 7, 7, 7);
SELECT *FROM RESULTS;

DROP table RESULTS;