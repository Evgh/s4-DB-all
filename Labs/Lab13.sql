-- task 1
use UniversityLab4
go
Create procedure PSUBJECT as
begin
	declare @count int = (select count(*) from SUBJECTS)
	select SUBJECT, SUBJECT_NAME, PULPIT from SUBJECTS
	return @count
end
go

declare @count int
exec @count = PSUBJECT
print @count



-- task 2

USE [UniversityLab4]
GO

/****** Object:  StoredProcedure [dbo].[PSUBJECT]    Script Date: 27.04.2021 23:51:07 ******/

ALTER procedure [dbo].[PSUBJECT] @p varchar(20) = null,  @c int output as
begin
	declare @count int = (select count(*) from SUBJECTS)
	set @c  = (select count(*) from SUBJECTS where PULPIT = @p)
	select SUBJECT, SUBJECT_NAME, PULPIT from SUBJECTS where PULPIT = @p
	return @count
end
GO

declare @crez int, @count int
exec @count = PSUBJECT @p = 'ИСиТ', @c = @crez output
print @count
print @crez


-- task 3
use UniversityLab4
go
ALTER procedure [dbo].[PSUBJECT] @p varchar(20) = null as
begin
	declare @count int = (select count(*) from SUBJECTS)
	select SUBJECT, SUBJECT_NAME, PULPIT from SUBJECTS where PULPIT = @p
	return @count
end
GO

Create table #SUBJECT
(
	SUBJECT char(10) primary key,
	SUBJECT_NAME varchar(100),
	PULPIT char(20) -- foreign key references PULPIT(PULPIT) 
)

insert #SUBJECT exec PSUBJECT @p = 'ИСиТ'
select * from #SUBJECT
drop table #SUBJECT

-- task 4
go
CREATE PROCEDURE PAUDITORIUM_INSERT @a char(20), @n varchar(50), @c int = 0, @t char(10) as
begin 
	begin try
		insert into AUDITORIUM values
		(@a, @t, @c, @n)

		return 1
	end try
	begin catch
		print cast (error_number() as varchar(6)) + ' ' + cast (error_severity() as varchar(6)) + ' ' + error_message() 
		
		return -1
	end catch

end
go

Declare @rez int

begin tran
exec @rez = PAUDITORIUM_INSERT @a = '207-1', @t = 'ЛБ-К', @c = 15, @n = '207-1' 
print @rez
if @rez = 1
	select * from AUDITORIUM
 
rollback


begin tran


exec @rez = PAUDITORIUM_INSERT @a = '206-1', @t = 'ЛБ-К', @c = 15, @n = '207-1' 
print @rez
if @rez = 1
	select * from AUDITORIUM
 
rollback

-- task 5
go
CREATE PROCEDURE PPULPIT_SUBJECTS @p char(20) as
begin
	if (@p not in (select PULPIT from PULPIT))
		begin
			raiserror('Ошибка в параметрах', 11, 1)
			return 0
		end
	DECLARE @pulpitName nvarchar(50) = @p
	DECLARE @i int = 0
	DECLARE @subjectName nvarchar(15), @subjectline nvarchar(150) = '', @subjectPulpit nvarchar(50)
	DECLARE subjects cursor local dynamic for
		SELECT SUBJECT.SUBJECT, SUBJECT.PULPIT from SUBJECT
	
		open subjects

			fetch from subjects into @subjectName, @subjectPulpit
			if (@subjectPulpit = @pulpitName)
				set @subjectline = trim(@subjectName) + ', ' + @subjectline
					
			while @@FETCH_STATUS = 0
				begin
					fetch from subjects into @subjectName, @subjectPulpit
					if (@subjectPulpit = @pulpitName)
					begin
						set @subjectline = trim(@subjectName) + ', ' + @subjectline
						set @i = @i + 1
					end
				end

		close subjects
		if len(@subjectline) > 0
			set @subjectline = left(@subjectline, len(@subjectline)-1)
		else
			set @subjectline = 'нет'
		print char(9) + char(9) + 'Дисциплины: ' + @subjectline
	
	return @i
end
go

declare @count int
exec @count = PPULPIT_SUBJECTS @p = 'ИСиТ'

print @count
go
declare @count int
exec @count = PPULPIT_SUBJECTS @p = 'ИСвыа'

-- task 6
go
CREATE PROCEDURE PAUDITORIUM_INSERT_TYPE @a_ char(20), @n_ varchar(50), @c_ int = 0, @t_ char(10), @tn_ varchar(50) as
begin
declare @err nvarchar(50) = 'Ошибка: '
declare @rez int
	set transaction isolation level SERIALIZABLE
	begin tran
		begin try
			insert into AUDITORIUM_TYPE values (@t_, @tn_)
			exec @rez = PAUDITORIUM_INSERT @a = @a_, @n = @n_, @c = @c_, @t = @t_
				if (@rez = -1)
					begin
						return -1
					end
		end try
		begin catch
			set @err = @err + error_message()
			raiserror(@err, 11, 1)
			rollback
			return -1
		end catch
	commit tran
	return 1
end
go
declare @rez int
begin tran
exec @rez = PAUDITORIUM_INSERT_TYPE @a_ = '208-1', @n_ = '208-1', @c_ = 15, @t_ = 'AUT2', @tn_ = 'AUDITORIUM TYPE 2' 
print @rez
if @rez = 1
	select * from AUDITORIUM
	select * from AUDITORIUM_TYPE
rollback
go

-- task 7
use Lab2
go
create procedure PReportsByDate as
begin

DECLARE reportCursor cursor local dynamic for
	SELECT Дата, count(*) from [Финансовые отчеты] group by Дата order by Дата asc
DECLARE curReportCursor cursor local dynamic for
	SELECT Название_предприятия, Название_показателя, Значение_показателя from [Финансовые отчеты] order by Дата, Название_предприятия asc

DECLARE @date Date, @reportsCount int, @i int = 0
Declare @name nvarchar(50), @propertyName nvarchar(50), @propertyValue float
	
open reportCursor
open curReportCursor
	
	fetch from reportCursor into @date, @reportsCount
	print @date
	while @@FETCH_STATUS = 0
	begin
		set @i = 0
		
		while @i < @reportsCount
			begin
				fetch from curReportCursor into @name, @propertyName, @propertyValue
				print char(9) + @name + ': ' + @propertyName + ' - ' + cast(@propertyValue as nvarchar(10))  -- tab 
				set @i = @i+1	
			end

		fetch from reportCursor into @date, @reportsCount
		if (@@FETCH_STATUS = 0) print @date
	end

close reportCursor
close curReportCursor

end
exec PReportsByDate
go

-- task 8 
use UniversityLab4
go
create procedure PFACULTY_REPORT @f char(10) = null, @p char(10) = null as
begin
	DECLARE @faculty nvarchar(10), @pulpitcount int, @i int = 0
	DECLARE @pulpitName nvarchar(50), @teacherCount int, @j int = 0
	DECLARE @subjectName nvarchar(15), @subjectline nvarchar(150) = '', @subjectPulpit nvarchar(50)
	DECLARE facultyCount cursor local dynamic for
		SELECT FACULTY.FACULTY, count(*) from FACULTY inner join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
		group by FACULTY.FACULTY order by FACULTY.FACULTY asc
	DECLARE pulpits cursor local dynamic for
		SELECT PULPIT.PULPIT, count(*) from PULPIT left outer join TEACHER on PULPIT.PULPIT = TEACHER.PULPIT group by FACULTY, PULPIT.PULPIT order by FACULTY asc
	declare @rezcount int = 0

	open facultyCount
	open pulpits


	if (@f is null AND @p is null)
	begin
	
	
		fetch from facultyCount into @faculty, @pulpitcount
		print 'Факультет: ' + @faculty
		while @@FETCH_STATUS = 0
		begin
			set @i = 0
		
			while @i < @pulpitcount
				begin
					set @subjectline = ''
					fetch from pulpits into @pulpitName,@teacherCount
					print char(9) + 'Кафедра: ' + @pulpitName
					print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
					exec PPULPIT_SUBJECTS @p = @pulpitName
					set @i = @i + 1
				end 



			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			set @rezcount = @rezcount + 1
		end

		

		return @rezcount
	

	

	end
	if (@f is not null AND @p is null)
	begin
		if (@f not in (select FACULTY from FACULTY))
		begin
			raiserror('Факультет не найден', 11, 1)
			return -1
		end
		fetch from facultyCount into @faculty, @pulpitcount
		if (@faculty = @f)
		begin
			begin
			set @i = 0
		
			while @i < @pulpitcount
				begin
					set @subjectline = ''
					fetch from pulpits into @pulpitName,@teacherCount
					print char(9) + 'Кафедра: ' + @pulpitName
					print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
					exec PPULPIT_SUBJECTS @p = @pulpitName
					set @i = @i + 1
				end 



			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			return @pulpitCount
			
		end
	end
		while (@@FETCH_STATUS = 0)
		begin
			fetch from facultyCount into @faculty, @pulpitcount
			if (@faculty = @f)
			begin
			begin
			set @i = 0
		
			while @i < @pulpitcount
				begin
					set @subjectline = ''
					fetch from pulpits into @pulpitName,@teacherCount
					print char(9) + 'Кафедра: ' + @pulpitName
					print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
					exec PPULPIT_SUBJECTS @p = @pulpitName
					set @i = @i + 1
				end 



			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			return @pulpitCount
		end
		end
		end

		

	end

	if(@p is not null)
	begin
		if (@p not in (select PULPIT from PULPIT))
		begin
			raiserror('Кафедра не найдена', 11, 1)
			return -1
		end
		fetch from facultyCount into @faculty, @pulpitcount
		if (@p in (select PULPIT from FACULTY inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY where FACULTY.FACULTY = @faculty))
		begin
			begin
			set @i = 0
		
			while @i < @pulpitcount
				begin
					set @subjectline = ''
					fetch from pulpits into @pulpitName,@teacherCount
					if (@pulpitName = @p)
					begin
						print char(9) + 'Кафедра: ' + @pulpitName
						print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
						exec @rezcount = PPULPIT_SUBJECTS @p = @pulpitName
						return @rezcount
					end
				end 



			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			return @pulpitCount
			
		end
		end
		while (@@FETCH_STATUS = 0)
		begin
			fetch from facultyCount into @faculty, @pulpitcount
			if (@p in (select PULPIT from FACULTY inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY where FACULTY.FACULTY = @faculty))
			begin
				begin
				set @i = 0
		
				while @i < @pulpitcount
					begin
						set @subjectline = ''
						fetch from pulpits into @pulpitName,@teacherCount
						if (@pulpitName = @p)
						begin
							print char(9) + 'Кафедра: ' + @pulpitName
							print char(9) + char(9) + 'Количество преподавателей: ' + cast(@teacherCount as nvarchar(10))
							exec @rezcount = PPULPIT_SUBJECTS @p = @pulpitName
							return @rezcount
						end
				end 



			fetch from facultyCount into @faculty, @pulpitcount
			if (@@FETCH_STATUS = 0) print 'Факультет: ' + @faculty
			return @pulpitCount
			
		end
		end
		end

		

	end
	
	close facultyCount
	close pulpits
end
go
declare @rez int
exec @rez = PFACULTY_REPORT 
print '----------- ' + cast (@rez as nvarchar(10)) 
go
declare @rez int
exec @rez = PFACULTY_REPORT @f = 'ХТиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go
go
declare @rez int
exec @rez = PFACULTY_REPORT @p = 'ИСиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go

declare @rez int
exec @rez = PFACULTY_REPORT @p = 'ИСssиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go
declare @rez int
exec @rez = PFACULTY_REPORT @f = 'ИСssиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go


-------------
go
drop procedure PSUBJECT
drop procedure PPULPIT_SUBJECTS
drop procedure PAUDITORIUM_INSERT_TYPE
drop procedure PFACULTY_REPORT
