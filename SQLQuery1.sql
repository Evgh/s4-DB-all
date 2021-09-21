use E_Univer;

-- 1 
CREATE table TABLE1
(
	t1 int,
	t2 int 
)

INSERT INTO TABLE1 values (11, 0), (12, 0), (13, 0), (4, 0), (5, 0), (6, 0);
select *from TABLE1;

CREATE table TABLE2
(
	t21 int identity(1,1),
	t22 int, 
	t23 int
)

INSERT into TABLE2 (t22, T23) values (convert(int, GETDATE()), (select sum(t1)/count(t1) from TABLE1));
SELECT * FROM TABLE2;

-- 2
USE E_Univer;
SELECT distinct STUDENT.NAME, PROGRESS.NOTE 
	FROM STUDENT join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	WHERE PROGRESS.NOTE > 8 or PROGRESS.NOTE < 4


-- 3 
USE E_Univer;
SELECT STUDENT.NAME 
	FROM STUDENT join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
	join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
	WHERE PROGRESS.NOTE <any (SELECT PROGRESS.NOTE FROM STUDENT join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
								join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
								join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
								WHERE faculty.FACULTY = 'ТОВ')
	and FACULTY.FACULTY != 'ТОВ'


-- 4 
USE E_Univer;
SELECT sum(PROGRESS.NOTE)/count(*) [средняя оценка по предмету СУБД]
	FROM PROGRESS 
	WHERE PROGRESS.SUBJECT = 'СУБД'


-- 5
--SELECT STUDENT.NAME FROM STUDENT 
--	WHERE STUDENT.NAME != all (SELECT STUDENT.NAME FROM STUDENT
--							   union 
--							   SELECT STUDENT.NAME FROM STUDENT);

(SELECT a.NAME FROM STUDENT as a
except 
SELECT aa.NAME FROM STUDENT as aa)

union

(SELECT aa.NAME FROM STUDENT as aa
except 
SELECT a.NAME FROM STUDENT as a)


-- 6 
GO
CREATE VIEW[Средняя_оценка]
	as SELECT sum(PROGRESS.NOTE)/count(*) [средняя оценка по предмету СУБД]
	FROM PROGRESS 
	WHERE PROGRESS.SUBJECT = 'СУБД' 
GO 

insert into Средняя_оценка values (1);

select * from Средняя_оценка