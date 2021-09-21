-- 1.1
USE E_Univer;
exec SP_HELPINDEX'AUDITORIUM';
exec SP_HELPINDEX'AUDITORIUM_TYPE';
exec SP_HELPINDEX'FACULTY';
exec SP_HELPINDEX'GROUPS';
exec SP_HELPINDEX'LESSONS';
exec SP_HELPINDEX'PROGRESS';
exec SP_HELPINDEX'PULPIT';
exec SP_HELPINDEX'STUDENT';
exec SP_HELPINDEX'SUBJECT';
exec SP_HELPINDEX'STUDENT';
exec SP_HELPINDEX'TEACHER';
exec SP_HELPINDEX'TIMETABLE';
exec SP_HELPINDEX'WEEK_DAYS';

-- 1.2
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table #INDEXES_1;
CREATE table #INDEXES_1
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)
CREATE clustered index #INDEXES_1_CL on #INDEXES_1(IKEY);

SET nocount ON;
DECLARE @i int = 0;
WHILE @i < 1000 
	begin
		INSERT #INDEXES_1 values (@i, 'mes' + cast(@i as varchar(3)), floor(1000*RAND()));
		SET @i = @i +1;
	end

SELECT * FROM #INDEXES_1
		WHERE IKEY between 300 and 800;

-- 2
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table #INDEXES_2;
CREATE table #INDEXES_2
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)
Drop index #INDEXES_2_NONCLU on #INDEXES_2;
CREATE index #INDEXES_2_NONCLU on #INDEXES_2(IMES,IKEY);

SET nocount ON;
DECLARE @i2 int = 0;
WHILE @i2 < 10000 
	begin
		INSERT #INDEXES_2 values (@i2, 'mes' + cast(@i2 as varchar(3)), floor(1000*RAND()));
		SET @i2 = @i2 +1;
	end

SELECT * FROM #INDEXES_2
		WHERE IKEY between 300 and 800 AND IMES like '%3'
		ORDER BY IKEY, IMES;

SELECT * FROM #INDEXES_2
		WHERE IKEY = 500 AND IMES like '%3'
		ORDER BY IKEY, IMES;

-- 3
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table #INDEXES_3;
CREATE table #INDEXES_3
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)
CREATE index #INDEXES_3_ on #INDEXES_3(IMES)INCLUDE(IKEY);

SET nocount ON;
DECLARE @i3 int = 0;
WHILE @i3 < 10000 
	begin
		INSERT #INDEXES_3 values (@i3, ('mes' + cast(@i3 as varchar(3))), floor(1000*RAND()));
		SET @i3 = @i3 +1;
	end

SELECT IKEY FROM #INDEXES_3
		WHERE IMES like '%3'

-- 4
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table #INDEXES_4;
CREATE table #INDEXES_4
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)

SET nocount ON;
DECLARE @i4 int = 0;
WHILE @i4 < 10000 
	begin
		INSERT #INDEXES_4 values (@i4, ('mes' + cast(@i4 as varchar(3))), floor(1000*RAND()));
		SET @i4 = @i4 +1;
	end

Drop index #INDEXES_4_WHERE on #INDEXES_4;
CREATE index #INDEXES_4_WHERE on #INDEXES_4(IKEY) where (IKEY > 300 AND IKEY < 800);

SELECT * FROM #INDEXES_4 WHERE IKEY = 100;
SELECT * FROM #INDEXES_4 WHERE (IKEY > 300 AND IKEY < 800); 
SELECT * FROM #INDEXES_4 WHERE IKEY between 200 and 700; 


-- 5
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table INDEXES_5;
CREATE table INDEXES_5
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)
CREATE index INDEXES_5_ on INDEXES_5(IKEY);

--SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
--        FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
--        OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
--        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
--        --WHERE name is not null;

SELECT a.object_id, object_name(a.object_id) AS TableName,
    a.index_id, name AS IndedxName, avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats
    (DB_ID (N'AdventureWorks2016_EXT')
        , OBJECT_ID(N'HumanResources.Employee')
        , NULL
        , NULL
        , NULL) AS a
	INNER JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id;

SET nocount ON;
DECLARE @i5 int = 0;
WHILE @i5 < 10000 
	begin
		INSERT INDEXES_5 values (@i5, ('mes' + cast(@i5 as varchar(3))), floor(1000*RAND()));
		SET @i5 = @i5 +1;
	end

INSERT top(10000) INDEXES_5(TIND, IMES, IKEY) select TIND, IMES, IKEY from INDEXES_5;


ALTER index INDEXES_5_ on INDEXES_5 reorganize;
ALTER index INDEXES_5_ on INDEXES_5 rebuild with (online = off);

-- 6
USE E_Univer;
checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS

-- DROP table INDEXES_6;
CREATE table INDEXES_6
(
	TIND int,
	IMES varchar(10), 
	IKEY int 
)
CREATE index INDEXES_6_ on INDEXES_6(IMES)INCLUDE(IKEY) with (fillfactor = 65);

INSERT top(10000) INDEXES_6(TIND, IMES, IKEY) select TIND, IMES, IKEY from INDEXES_6;

SELECT a.object_id, object_name(a.object_id) AS TableName,
    a.index_id, name AS IndedxName, avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats
    (DB_ID (N'AdventureWorks2016_EXT')
        , OBJECT_ID(N'HumanResources.Employee')
        , NULL
        , NULL
        , NULL) AS a
	INNER JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id;


-- 7 
USE KASPER_MyNewBase;

DROP index CREDITS_MARK on CREDITS;
DROP index STUDENTS_NAME_SURNAME on STUDENTS;

CREATE index CREDITS_MARK on CREDITS(credit_mark);
CREATE index STUDENTS_NAME_SURNAME on STUDENTS(student_id) INCLUDE (student_name, student_surname);


-- Студент с самой высокой оценкой по каждому предмету
SELECT DISCIPLINES.discipline_name [Предмет], STUDENTS.student_name [Студент], CREDITS.credit_mark [Оценка]  
		FROM CREDITS join STUDENTS on CREDITS.student_id = STUDENTS.student_id
				join DISCIPLINES on DISCIPLINES.discipline_code = CREDITS.discipline_code
		WHERE STUDENTS.student_id in 
				(SELECT top(1) student_id 
					FROM CREDITS 
					WHERE CREDITS.discipline_code = DISCIPLINES.discipline_code 
					ORDER BY credit_mark desc);
