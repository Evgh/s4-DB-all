----------------------------------------------------------------------- 1
use E_Univer;

--drop procedure psubject;

declare task131 cursor for 
				select SUBJECT.SUBJECT, 
					   SUBJECT.SUBJECT_NAME, 
					   SUBJECT.PULPIT from SUBJECT;

go
create procedure psubject 
as
begin 


	declare @subj char(7), @subjName char(40), @pulp char(7); 
	declare @mess varchar(2000), @num int = 0;
	
	select @subj = 'Код', @subjName = 'Дисциплина', @pulp = 'Кафедра'; 
	set @mess = @subj + ' ' + @subjname + ' ' + @pulp;

	open task131

		fetch task131 into @subj, @subjName, @pulp;
		while @@FETCH_STATUS = 0
			begin 
				set @mess = @mess + char(13) + @subj + ' ' + @subjName + ' ' + @pulp;
				set @num = @num + 1;
				fetch task131 into @subj, @subjName, @pulp;
			end
	close task131

	print @mess;
	return @num;
end

go 

declare @t1 int;
exec @t1 = psubject;
print 'Количество строк: ' + rtrim(cast(@t1 as varchar(3)));



------------------------------------------------------------------- 2 
--- Alter
USE [E_Univer]
GO
/****** Object:  StoredProcedure [dbo].[psubject]    Script Date: 04.06.2021 2:49:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[psubject] @p char(40) = NULL, @c int output
as
begin 

	declare @subj char(7), @subjName varchar(20), @pulp char(6); 
	declare @mess varchar(2000), @num int = 0;
	
	select @subj = 'Код', @subjName = 'Дисциплина', @pulp = 'Кафедра'; 
	set @mess = @subj + ' ' + @subjname + ' ' + @pulp;

	set @c = 0;

	open task131

		fetch task131 into @subj, @subjName, @pulp;
		while @@FETCH_STATUS = 0
			begin 
				
				if @pulp = @p
					begin
						set @mess = @mess + char(13) + @subj + ' ' + @subjName + ' ' + @pulp;
						set @c = @c + 1;
					end 

				set @num = @num + 1;
				fetch task131 into @subj, @subjName, @pulp;
			end
	close task131

	print @mess;
	return @num;
end
-- alter ends


declare @t2 int, @t22 int, @pulp nvarchar(10) = 'ИСИТ';
exec @t2 = psubject @pulp, @t22 output;
print 'Количество строк: ' + rtrim(cast(@t2 as varchar(3)));
print 'Количество в результирующем наборе: ' + cast(@t22 as varchar(3));




------------------------------------------------------------------- 3
go
create procedure psubject2 @p char(40) = NULL
as
begin 
	
	declare @num int = (select count(*) from SUBJECT);
	select * from SUBJECT where SUBJECT.PULPIT = @p;
end
go 

create table #subjects 
(
	subj char(10),
	nam varchar(100),
	pulp char(20)
)

insert #subjects exec psubject2 @p = 'ИСИТ'

select * from #subjects;


------------------------------------------------------------------ 4
go
create procedure pauditorium_insert @a char(20), @n varchar(50), @c int = 0, @t char(10)
as 
begin

	begin try 
		insert into AUDITORIUM(AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE) values (@a, @n, @c, @t);
		return 1;
	end try
	begin catch 
		print 'номер ошибки: ' + cast(error_number() as varchar(10));
		print 'сообщение: ' + error_message();
		print 'уровень: ' + cast(error_severity() as varchar(10));
		print 'метка: ' + cast(error_state() as varchar(10));
		print 'номер строки: ' + cast(error_line() as varchar(10));

		if error_procedure() is not null 
			print 'процедура: ' + error_procedure();

		return -1;
	end catch
end
go

declare @t4 int;
exec @t4 = pauditorium_insert @a = '201-3а', @t = 'ЛК', @n = '201-3a', @c = 120;


------------------------------------------------------------------------------------------------ 5
use E_Univer;


--drop procedure subject_report;

go
create procedure subject_report @p char(10) 
as
begin 

	declare @subjName char(40), @pulp char(6), @mess varchar (1000) = '', @num int = 0;

	begin try
		declare task135 cursor local for 
				select SUBJECT.SUBJECT_NAME, SUBJECT.PULPIT from SUBJECT;
		
		if not exists (select * from subject where PULPIT = @p)
			raiserror('ошибка', 11, 1);
		
		open task135;
		fetch task135 into @subjName, @pulp;
		
		while @@FETCH_STATUS = 0
			begin 				
				if (@pulp = @p)
					begin 
						set @mess = @mess + rtrim(@subjName) + ', ';
						set @num = @num + 1;						
					end

				fetch task135 into @subjName, @pulp;
			end
		close task135;
		print 'Список: ' + @mess;
		return @num;
	end try

	begin catch 
		print 'ошибка в параметрах';
		if error_procedure() is not null 
			print 'процедура: ' + error_procedure();
		return @num;
	end catch 

end
go 


declare @rc int;  
exec @rc = subject_report @p  = 'ИСИТ';  
print 'количество предметов = ' + cast(@rc as varchar(3)); 


------------------------------------------------------------------------------------ 6
use E_Univer;
-- drop procedure pauditorium_insertx;
go 
create procedure pauditorium_insertx @a char(20), @n varchar(50), @c int = 0, @t char(10), @tn varchar(50)
as 

declare @rc int = 1;
begin 
	begin try 

		set transaction isolation level SERIALIZABLE;          
		begin tran	
			insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values (@t, @tn);
			exec @rc = pauditorium_insert @a, @n, @c, @t;
		commit tran
		return @rc;

	end try 
	begin catch 
		print 'номер ошибки: ' + cast(error_number() as varchar(10));
		print 'сообщение: ' + error_message();
		print 'уровень: ' + cast(error_severity() as varchar(10));
		print 'метка: ' + cast(error_state() as varchar(10));
		print 'номер строки: ' + cast(error_line() as varchar(10));

		if error_procedure() is not null 
			print 'процедура: ' + error_procedure();

		rollback tran;
		return -1;
	end catch
end 
go


declare @t6 int;
exec @t6 = pauditorium_insertx @a = '105-4', @t = 'ДК1', @n = '104-4', @c = 5, @tn = 'Деканат1';




------------------------------------------------------------------------------------------------------ 7
use KASPER_MyNewBase

-- Студент с самой высокой оценкой по каждому предмету
SELECT DISCIPLINES.discipline_name [Предмет], STUDENTS.student_name [Студент], CREDITS.credit_mark [Оценка]  
		FROM CREDITS join STUDENTS on CREDITS.student_id = STUDENTS.student_id
				join DISCIPLINES on DISCIPLINES.discipline_code = CREDITS.discipline_code
		WHERE STUDENTS.student_id in 
				(SELECT top(1) student_id 
					FROM CREDITS 
					WHERE CREDITS.discipline_code = DISCIPLINES.discipline_code 
					ORDER BY credit_mark desc);
