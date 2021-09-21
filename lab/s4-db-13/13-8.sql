use E_Univer;

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
print '----------- Результат: ' + cast (@rez as nvarchar(10)) 
--go
--declare @rez int
--exec @rez = PFACULTY_REPORT @f = 'ХТиТ'
--print '----------- ' + cast (@rez as nvarchar(10)) 
--go
--go
--declare @rez int
--exec @rez = PFACULTY_REPORT @p = 'ИСиТ'
--print '----------- ' + cast (@rez as nvarchar(10)) 
--go

--declare @rez int
--exec @rez = PFACULTY_REPORT @p = 'ИСssиТ'
--print '----------- ' + cast (@rez as nvarchar(10)) 
--go
--declare @rez int
--exec @rez = PFACULTY_REPORT @f = 'ИСssиТ'
--print '----------- ' + cast (@rez as nvarchar(10)) 
--go


-------------
go
--drop procedure PSUBJECT
drop procedure PPULPIT_SUBJECTS
drop procedure PFACULTY_REPORT
