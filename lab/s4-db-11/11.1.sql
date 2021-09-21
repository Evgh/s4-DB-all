-- 1 
USE E_Univer;

DECLARE @tv char(20), @t char(300) = '';
DECLARE task1 CURSOR for SELECT SUBJECT.SUBJECT FROM PULPIT join SUBJECT on PULPIT.PULPIT = SUBJECT.PULPIT WHERE PULPIT.PULPIT = 'ИСиТ';

OPEN task1
	FETCH task1 into @tv;
	PRINT 'Дисциплины кафедры ИСиТ:';

	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @t = RTRIM(@tv) + ',' + @t;
			FETCH task1 into @tv;
		END 
	
	PRINT @t; 
CLOSE task1

-- 2
-- 2.1
USE E_Univer;
DECLARE task_21 CURSOR LOCAL for SELECT PULPIT.PULPIT, PULPIT.FACULTY FROM PULPIT;

DECLARE @pulpit2 varchar(10), @faculty2 varchar(10);

OPEN task_21
	FETCH task_21 into @pulpit2, @faculty2;
	PRINT '1 кафедра: ' + ' ' + @pulpit2 + ' ' + @faculty2;
	GO
		DECLARE @pulpit2 varchar(10), @faculty2 varchar(10);
		FETCH task_21 into @pulpit2, @faculty2;
		PRINT '2 кафедра: ' + ' ' + @pulpit2 + ' ' + @faculty2;
	GO


-- 2.2 
USE E_Univer;

DECLARE task_2 CURSOR GLOBAL for SELECT PULPIT.PULPIT, PULPIT.FACULTY FROM PULPIT;
DECLARE @pulpit2 char(10), @faculty2 char(10);

OPEN task_2
	FETCH task_2 into @pulpit2, @faculty2;
	PRINT '1 кафедра: ' + ' ' + @pulpit2 + ' ' + @faculty2;

	GO
		DECLARE @pulpit2 char(10), @faculty2 char(10);
		FETCH task_2 into @pulpit2, @faculty2;
		PRINT '2 кафедра: ' + ' ' + @pulpit2 + ' ' + @faculty2;
	GO

CLOSE task_2

-- 3
-- 3.1
USE E_Univer;
DECLARE task_31 CURSOR LOCAL STATIC for SELECT PULPIT.PULPIT, PULPIT.FACULTY FROM PULPIT;
DECLARE @pulpit3 varchar(5), @faculty3 varchar(5), @amount0 int = 0;

OPEN task_31
	SET nocount ON;
	FETCH task_31 into @pulpit3, @faculty3;
	PRINT 'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 

	INSERT into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ППАП1', 'Производства печатной аниме-продукции', 'АН');	
	INSERT into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ППАП18+', 'Производства печатной аниме-продукции 18+', 'АН');
	PRINT 'Количество строк после 2х вставок : ' + cast(@@CURSOR_ROWS as varchar(5)); 

	DELETE from PULPIT where PULPIT.PULPIT = 'ППАП18+';
	PRINT 'Количество строк после одного удаления: ' + cast(@@CURSOR_ROWS as varchar(5)); 

	WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @amount0 = @amount0 + 1;
			FETCH task_31 into @pulpit3, @faculty3;
		END
    PRINT 'Количество строк по циклу while: ' + cast(@amount0 as varchar(5));

	DECLARE @trueAmount int;
	SET @trueAmount = (select count(*) from PULPIT)
    PRINT 'Настоящее количество строк: ' + cast(@trueAmount as varchar(5));

	DELETE from PULPIT where PULPIT.PULPIT = 'ППАП1';
CLOSE task_31


-- 3.2
USE E_Univer;
DECLARE task_32 CURSOR LOCAL DYNAMIC for SELECT PULPIT.PULPIT FROM PULPIT;
DECLARE @pulpit32 varchar(5), @amount0 int = 0;

OPEN task_32
	FETCH task_32 into @pulpit32;
	PRINT 'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
	
	DECLARE @trueAmount int;
	SET @trueAmount = (select count(*) from PULPIT)
    PRINT 'Настоящее количество строк: ' + cast(@trueAmount as varchar(5));

	INSERT into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ППАП1', 'Производства печатной аниме-продукции', 'АН');	
	INSERT into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ППАП18+', 'Производства печатной аниме-продукции 18+', 'АН');
	
	SET @amount0 = 0;
	WHILE @@FETCH_STATUS = 0 
		BEGIN
			SET @amount0 = @amount0 + 1;
			FETCH task_32 into @pulpit32;
		END

    PRINT 'Количество строк после 2х вставок: ' + cast(@amount0 as varchar(5));

	DELETE from PULPIT where PULPIT.PULPIT = 'ППАП18+';
	DELETE from PULPIT where PULPIT.PULPIT = 'ППАП1';	
CLOSE task_32;


-- 4 
USE E_Univer;
--DECLARE task_4 CURSOR LOCAL DYNAMIC for SELECT PULPIT.PULPIT FROM PULPIT;

--DECLARE Primer1 CURSOR LOCAL DYNAMIC SCROLL 
--				for 
--				SELECT SUBJECT.SUBJECT FROM PULPIT join SUBJECT on PULPIT.PULPIT = SUBJECT.PULPIT WHERE PULPIT.PULPIT = 'ИСиТ';


DECLARE Primer1 cursor local dynamic SCROLL                               
               for 
			   SELECT row_number() over (order by PULPIT.PULPIT) N, PULPIT.PULPIT FROM PULPIT 


DECLARE  @tc int, @rn char(50);  

	OPEN Primer1;
	FETCH  Primer1 into  @tc, @rn; 	
	print 'следующая строка        : ' + cast(@tc as varchar(3))+ rtrim(@rn);    
	
	FETCH  LAST from  Primer1 into @tc, @rn;       
	print 'последняя строка          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  FIRST from  Primer1 into @tc, @rn;       
	print 'первая строка          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  NEXT from  Primer1 into @tc, @rn;       
	print 'следующая строка за текущей          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  PRIOR from  Primer1 into @tc, @rn;       
	print 'предыдущая строка от текущей          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  ABSOLUTE 3 from  Primer1 into @tc, @rn;       
	print 'третья строка от начала          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  ABSOLUTE -3 from Primer1 into @tc, @rn;       
	print 'третья строка от конца          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  FIRST from  Primer1 into @tc, @rn;       
	print 'первая строка          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  RELATIVE  5 from  Primer1 into @tc, @rn;       
	print 'пятая строка вперед от текущей          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

	FETCH  RELATIVE -5 from  Primer1 into @tc, @rn;       
	print 'пятая строка назад от текущей          : ' +  cast(@tc as varchar(3))+ rtrim(@rn);      

 CLOSE Primer1;


 -- 5
USE E_Univer;
DECLARE task_5 CURSOR LOCAL DYNAMIC for SELECT PULPIT.PULPIT, PULPIT.PULPIT_NAME FROM PULPIT FOR UPDATE;
DECLARE @pulpit5 varchar(5), @pulpit_name varchar(30);

INSERT into PULPIT(PULPIT, PULPIT_NAME, FACULTY) values ('ЯЭЮ', 'Случайный текст', 'АН');	


OPEN task_5

	FETCH LAST from task_5 into @pulpit5, @pulpit_name;
	PRINT 'Последняя строка на момент начала работы: ' + @pulpit5 + ' ' + @pulpit_name;

	UPDATE PULPIT set PULPIT_NAME = 'Маму не обижай' where CURRENT OF task_5;
	FETCH LAST from task_5 into @pulpit5, @pulpit_name;
	PRINT @pulpit5 + ' ' + @pulpit_name;

	DELETE PULPIT where CURRENT OF task_5;
	FETCH LAST from task_5 into @pulpit5, @pulpit_name;
	PRINT 'Последняя строка на момент конца работы: ' + @pulpit5 + ' ' + @pulpit_name;
	
CLOSE task_5;
