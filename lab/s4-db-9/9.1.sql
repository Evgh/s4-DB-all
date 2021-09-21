 -- 1
DECLARE @symbol char = 'Z',
		@str varchar(5) = 'Zhbub',
		@myDateTime datetime,
		@myTime time,
		@number int,
		@smallNumber smallint, 
		@tinyNumber tinyint, 
		@numer numeric(12, 5);

SET @myTime = '12:00';
SET	@myDateTime = (Select getdate());

SELECT @smallNumber = 1,
	   @tinyNumber = 0,
	   @numer = 33.5;

SELECT @smallNumber small, @tinyNumber tiny, @numer [numeric], @number [int];
PRINT @symbol + ' ' + @str;
PRINT @myTime;
PRINT @myDateTime;

-- 2
USE E_Univer;
DECLARE @capacity float = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM);
IF @capacity > 200
	begin
		DECLARE @amount float = (select count(*) from AUDITORIUM),
				@lessThanAverage float = (select count(*) from (select * from AUDITORIUM where AUDITORIUM_CAPACITY < @capacity) as T); 
		SELECT 
			@amount [���-��],
			@capacity [������� �����������],
			@lessThanAverage [� ������������ ������ �������],
			@lessThanAverage/@amount * 100 [�������]; 
	end
ELSE 
	begin
		DECLARE @sumCapacity float = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM);
		PRINT '����� �����������: ';
		PRINT @sumCapacity;
	end

-- 3 
PRINT cast(@@ROWCOUNT as varchar) + ' - ����� ���������-��� �����'; 
PRINT cast(@@VERSION as varchar) + ' - ������ SQL Server';
PRINT cast(@@SPID as varchar) + ' - ���������� ��������� ������������� ��������, ��������-��� �������� �������� ��������-���'; 
PRINT cast(@@ERROR as varchar) + ' - ��� ��������� ������'; 
PRINT cast(@@SERVERNAME as varchar) + ' - ��� �������'; 
PRINT cast(@@TRANCOUNT as varchar) + ' - ���������� ������� ����������� ����������'; 
PRINT cast(@@FETCH_STATUS as varchar) + ' - �������� ��-�������� ���������� ����� ��������-������� ������'; 
PRINT cast(@@NESTLEVEL as varchar);

-- 4 

-- 4.1
DECLARE @z float, 
		@t int = 4,
		@x int = 5;

IF @t > @x
	begin
		SET @z = sin(@t)*sin(@t);
		PRINT 't > x, z = ' + cast(@z as varchar);
	end
ELSE IF @t < @x 
	begin
		SET @z = 4 * (@t + @x); 
		PRINT 't < x, z = ' + cast(@z as varchar);
	end
ELSE IF @t = @x
	begin 
		SET @z = 1 - exp(@x - 2);
		PRINT 't = x, z = ' + cast(@z as varchar);
	end

-- 4.2
DECLARE @surname varchar(20) = '����������',
		@name varchar(20) = '�������',
		@father varchar(20) = '����������',
		@fio varchar(20);
SET @fio = @surname + ' ' + cast(@name as varchar(1)) + '. ' + cast(@father as varchar(1)) + '.';
PRINT @fio;

-- 4.3
DECLARE @nextMonth date = DATEADD(MONTH, 1, GETDATE());
PRINT @nextMonth;

SELECT STUDENT.NAME [���], STUDENT.BDAY[���� ��������], DATEDIFF(YEAR, STUDENT.BDAY, @nextMonth) [���������� ���] 
	FROM STUDENT 
	WHERE DATEDIFF(MONTH, @nextMonth, STUDENT.BDAY)%12 = 0;

-- 4.4
SELECT STUDENT.IDGROUP[����� ������], SUBJECT.SUBJECT[�������], DATENAME(dw, PROGRESS.PDATE) [���� ������]
	FROM PROGRESS
		PROGRESS join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		join SUBJECT on SUBJECT.SUBJECT = PROGRESS.SUBJECT
	WHERE SUBJECT.SUBJECT = '����'
	GROUP BY STUDENT.IDGROUP, SUBJECT.SUBJECT, PROGRESS.PDATE


-- 5
USE E_Univer;
DECLARE @amount_ int;

IF (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM) > 200
	begin
		PRINT '���������� ��������� c ������������ ������ 200: ';
		SET @amount_ = (select count(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY > 200);
		PRINT @amount_;
	end
ELSE 
	begin
		PRINT '���������� ��������� c ������������ ������ 200: ';
		SET @amount_ = (select count(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < 200);
		PRINT @amount_;
	end

-- 6	
SELECT 
		case 
			when PROGRESS.NOTE >= 9 then '�����������'
			when PROGRESS.NOTE between 7 and 8 then '������'
			when PROGRESS.NOTE between 4 and 6 then '���������'
			else '�������������������'
		end [���������], 
		count(*) [���������� ������]
	FROM PROGRESS join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
		join FACULTY on FACULTY.FACULTY = GROUPS.FACULTY
	WHERE FACULTY.FACULTY = '���'
	GROUP BY
			case 
			when PROGRESS.NOTE >= 9 then '�����������'
			when PROGRESS.NOTE between 7 and 8 then '������'
			when PROGRESS.NOTE between 4 and 6 then '���������'
			else '�������������������'
		end
		
-- 7
USE E_Univer;
--DROP table #MyTable
CREATE table #MyTable 
(
	Num int identity(1, 1) primary key,
	String varchar(10) default 'Blob',
	TheDate datetime default GETDATE()
) 

DECLARE @i int = 0;
WHILE @i < 10
	begin
		INSERT #MyTable default values;
		SET @i = @i + 1;
	end

SELECT * FROM #MyTable


-- 8
begin 
	PRINT '� �������� ��������, ��� ����� ����� ������� ������������ ������������';
	PRINT '� ��������, ��� ������� �� ������ ������ ������';
	PRINT '� ������ ������, ��� ����� ������ ������ ����� �����';
	PRINT '� ��������';
	RETURN;
	PRINT '� ������ ������ ������';
end


-- 9
begin TRY
	--DROP table #MyErrorTable
	CREATE table #MyErrorTable 
	(
		Num int identity(1, 1) primary key check (Num > 10)
	) 
	INSERT into #MyErrorTable(Num) values (0)
end TRY 
begin CATCH 
	PRINT ERROR_NUMBER();
	PRINT ERROR_MESSAGE();
	PRINT ERROR_lINE();
	PRINT ERROR_PROCEDURE();
	PRINT ERROR_SEVERITY();
	PRINT ERROR_STATE();
end CATCH