USE KASPER_UNIVER;

SELECT *FROM STUDENT;

SELECT Группа[группа челика], Фамилия[челик] FROM STUDENT;

SELECT count(*)[Число_строк] FROM STUDENT;

SELECT count(*) FROM STUDENT Where Номер_зачетки < 4;

--INSERT into STUDENT values (6, 'Величко', 11); 
SELECT Distinct Top(3) Фамилия, Группа FROM STUDENT Order by Фамилия Desc;

