-- 1
/*
USE master;
CREATE database KASPER_UNIVER;
*/

-- 2
USE KASPER_UNIVER;
CREATE table STUDENT 
( 
	�����_������� int not null primary key,
	������� nvarchar(20) not null,
	������ int not null constraint groupCh check (������ > 0)
)

Select *from STUDENT;

--3
ALTER table STUDENT ADD ����_����������� date;
ALTER table STUDENT ADD constraint CK_����_����������� check (����_����������� >= '01:09:2016');

ALTER table STUDENT DROP CK_����_�����������;
ALTER table STUDENT DROP COLUMN ����_�����������;

--4
INSERT into STUDENT (�����_�������, �������, ������) values (1, '����������', 11), (2, '�������', 11);
INSERT into STUDENT values (3, '�����', 11), (4, '�������', 12);

-- 5
SELECT *FROM STUDENT;
SELECT ������[������ ������], �������[�����] FROM STUDENT;
SELECT count(*)[�����_�����] FROM STUDENT;
SELECT count(*) FROM STUDENT Where �����_������� < 4;

INSERT into STUDENT values (6, '�������', 11); 
SELECT Distinct Top(3) �������, ������ FROM STUDENT Order by ������� Desc;

-- 5.1
SELECT *FROM STUDENT;

UPDATE STUDENT Set ������ = 5;
DELETE FROM STUDENT Where �����_������� = 6;
SELECT *FROM STUDENT;

--6
Select *from student where ������ in (5, 6) AND �����_������� Between 2 and 4 AND ������� Like '�%';

DROP table STUDENT;

--7
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
INSERT into RESULTS values ('����������', 6, 6, 8), ('Lityagin', 9, 9, 6), ('Bozhko', 7, 7, 7);
SELECT *FROM RESULTS;

DROP table RESULTS;

-- 9
USE KASPER_MyBase;
--Select *from ��������;
--Select *from ������;
INSERT into �������� (�����_�������������, �������) values (000000, 'Knyazeva'), (666666, 'Pleshkova');
Select top(3) *from ��������;

--USE KASPER_MyBase;
DELETE FROM �������� where ������� = 'Knyazeva' or ������� = 'Pleshkova';
Select *from ��������;



-- 10
USE KASPER_UNIVER;
CREATE TABLE STUDENT
(
	�����_������� int primary key identity (100000, 1),
	��� varchar(50) not null,
	����_�������� date not null,
	Gender varchar(1),
	����_����������� date
);
ALTER table STUDENT ALTER COLUMN ����_����������� date not null;

INSERT into STUDENT values 
	('�������� �.�.', '01-05-1990', '�', '01-01-2019'),
	('������� �.�.', '19-10-1995', '�', '01-09-2019'),
	('���������� �.�.', '01-06-1999', '�', '01-09-2019'),
	('������� �.�.', '13-04-2005', '�', '01-09-2020');

SELECT *FROM STUDENT;
SELECT *FROM STUDENT where Gender = '�' and DATEDIFF(YEAR, ����_��������, ����_�����������) > 18;

DROP table STUDENT;
