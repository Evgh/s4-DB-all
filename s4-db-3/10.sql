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
