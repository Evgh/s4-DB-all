use UniversityLab4

-- 1
go
create function CountStudents(@faculty varchar(20)) returns int
as
begin
	declare @count int = 0
	set @count = (select count(*) 
				from Student inner join Groups on Student.IDGROUP = Groups.IDGROUP
				where Groups.FACULTY = @faculty)
	return @count
end
go
alter function CountStudents(@faculty varchar(20), @profession varchar(20)) returns int
as
begin
	declare @count int = 0
	set @count = (select count(*) 
				from Student inner join Groups on Student.IDGROUP = Groups.IDGROUP
				where Groups.FACULTY = @faculty AND Groups.PROFESSION = @profession)
	return @count
end
go

print dbo.CountStudents('ХТИТ','1-36 07 01')

go
-- 2
go
alter function PulpitSubjects(@pulpit varchar(20)) returns varchar(300)
as
begin
	declare @subjects varchar(300) = 'Дисциплины: ',
			@subject varchar(50)
	declare SubjectsCursor cursor local for
		select SUBJECT 
		from SUBJECTS 
		where SUBJECTS.PULPIT = @pulpit

	open SubjectsCursor
		fetch SubjectsCursor into @subject
		set @subjects = @subjects + RTRIM(@subject)
		if (@@FETCH_STATUS !=0)
			Set @subjects = 'Дисциплины: нет'
		while @@FETCH_STATUS = 0
		begin
			fetch SubjectsCursor into @subject
			set @subjects = @subjects + ', ' + RTRIM(@subject)
		end
	close SubjectsCursor
	
		
	return @subjects
end
go



select PULPIT, dbo.PulpitSubjects(PULPIT)
from PULPIT
go
-- 3
go
create function FacultyPulpit (@faculty varchar(30) = null, @pulpit varchar(30) = null) 
returns @result table 
				(
					faculty char(10),
					pulpit char(20)
				)
as 
begin
	if(@faculty is null)
	begin
		if (@pulpit is null)
		begin
			-- оба null
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			return
		end
		else
		begin
			-- faculty null
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where PULPIT.PULPIT = @pulpit
			return
		end

	end
	else 
	begin
		if (@pulpit is null)
		begin
			-- pulpit null
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where FACULTY.FACULTY = @faculty
			return
		end
		else
		begin
			-- оба не null
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where FACULTY.FACULTY = @faculty AND PULPIT.PULPIT = @pulpit
			return
		end
	end
return
end
go

drop function FacultyPulpit
select * from FacultyPulpit(null, null)
select * from FacultyPulpit('ХТИТ', null)
select * from FacultyPulpit(null, 'ЛВ')
select * from FacultyPulpit('ЛХФ', 'ЛВ')

go
-- 4
go
create function TeacherCount(@pulpit char(20)) returns int
as
begin
	Declare @teacherCount int = 0

	if (@pulpit is null)
		set @teacherCount = 
		(select count(*) 
		from TEACHERS)
	else
		set @teacherCount = 
		(select count(*) 
		from TEACHERS where PULPIT = @pulpit)

	return @teacherCount
end

select PULPIT, dbo.TeacherCount(PULPIT)
from PULPIT
select dbo.TeacherCount(NULL)

go
-- 5
go
use Lab2
go
create function GetReportValues(@enterprise nvarchar(30), @factor nvarchar(30), @date datetime) returns int
as
begin
	Declare @value int = 0
	SET @value = (select Значение_показателя
	from [Финансовые отчеты]
	where Название_предприятия = @enterprise AND Название_показателя = @factor AND Дата = @date)
	return @value
end
go
select Название_предприятия, Название_показателя,Дата , dbo.GetReportValues(Название_предприятия, Название_показателя,Дата) [Значение показателя] from [Финансовые отчеты]

go
create function GetReports(@enterprise nvarchar(30)) 
returns @result table
		(
			EnterpriseName nvarchar(50),
			Date date,
			FactorName nvarchar(50),
			FactorValue real			
		)
as
begin
	if (@enterprise is null)
	begin
		insert into @result
		select Название_предприятия, Дата, Название_показателя, Значение_показателя
		from [Финансовые отчеты]
		return
	end
	else
	begin
		insert into @result
		select Название_предприятия, Дата, Название_показателя, Значение_показателя
		from [Финансовые отчеты]
		where Название_предприятия =  @enterprise
		return
	end
	return
end
go

select * from dbo.GetReports(null)
select * from dbo.GetReports('Винокурня_Жиляк')

go

-- 6
use UniversityLab4
go
create function StudentCount(@faculty varchar(50)) returns int
as
begin
	 declare @studentCount int  = 0
	 set @studentCount = 
		(select count(*)
		from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
					 inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
		where FACULTY.FACULTY = @faculty)
	return @studentCount
end
go

go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	 declare @pulpitCount int = 0
	 set @pulpitCount = 
		(select count(*)
		from PULPIT
		where PULPIT.FACULTY = @faculty)
	return @pulpitCount
end
go
create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	 declare @professionCount int = 0
	 set @professionCount = 
		(select count(*)
		from PROFESSION
		where PROFESSION.FACULTY = @faculty)
	return @professionCount
end
go
create function GroupCount(@faculty varchar(50)) returns int
as
begin
	 declare @groupCount int = 0
	 set @groupCount = 
		(select count(*)
		from GROUPS
		where GROUPS.FACULTY = @faculty)
	return @groupCount
end
go


create function FacultyReport(@studentCount int) 
returns @result table 
		(
		faculty varchar(50),
		pulpitCount int, 
		groupCount int, 
		professionCount int
		)
as
begin
	declare FacultyCursor cursor local for
		select FACULTY
		from FACULTY
		where dbo.StudentCount(FACULTY) > @studentCount
	declare @faculty varchar(50)
	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
			(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.ProfessionCount(@faculty))

			fetch FacultyCursor into @faculty
		end

	close FacultyCursor
	return
end
go

select * from dbo.FacultyReport(5)

-- 7
go

alter procedure PFACULTY_REPORT2 @faculty char(10) = null, @pulpit char(10) = null as
begin
	declare facultyCursor cursor local for
		select faculty from FACULTY
	declare pulpitCursor cursor local for 
		select pulpit from PULPIT
	declare @result int = 0
	declare @currFaculty varchar(30), @currPulpit varchar(30), @subjectString varchar(300)


	open facultyCursor
	


	if(@faculty is null)
	begin
		if (@pulpit is null)
		begin
			-- оба null
			fetch facultyCursor into @currFaculty
			while @@FETCH_STATUS = 0
			begin
				print 'Факультет: ' + @currFaculty
				open pulpitCursor 
				fetch pulpitCursor into @currPulpit
				while @@FETCH_STATUS = 0
				begin
					if (exists (select * from PULPIT where FACULTY = @currFaculty AND PULPIT = @currPulpit)) 
					begin
						print char(9) + 'Кафедра ' + @currPulpit
						print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.TeacherCount(@currPulpit) as varchar(5))
						print char(9) +  char(9) + cast(dbo.PulpitSubjects(@currPulpit) as varchar(300))
					end
					
					fetch pulpitCursor into @currPulpit
				end
				close pulpitCursor
				fetch facultyCursor into @currFaculty
			end
			set @result = dbo.PulpitCount(@faculty)
		end
		else
		begin
			-- faculty null
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin		
				fetch pulpitCursor into @currPulpit
				while @@FETCH_STATUS = 0
				begin
					if(@currPulpit = @pulpit)
					begin
						print 'Факультет: ' + @currFaculty
						print char(9) + 'Кафедра ' + @currPulpit
						print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.TeacherCount(@currPulpit) as varchar(5))
						print char(9) +  char(9) + cast(dbo.PulpitSubjects(@currPulpit) as varchar(300))
						
					end
					fetch pulpitCursor into @currPulpit
				end
				set @result = @result + dbo.PulpitCount(@faculty)
				fetch facultyCursor into @currFaculty
			end
			close pulpitCursor
		end
	end
	else 
	begin
		if (@pulpit is null)
		begin
			-- pulpit null
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin
				if(@currFaculty = @faculty)
				begin
					print 'Факультет: ' + @currFaculty
					fetch pulpitCursor into @currPulpit
					while @@FETCH_STATUS = 0
					begin
						if (exists (select * from PULPIT where FACULTY = @currFaculty AND PULPIT = @currPulpit)) 
						begin
							print char(9) + 'Кафедра ' + @currPulpit
							print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.TeacherCount(@currPulpit) as varchar(5))
							print char(9) +  char(9) + cast(dbo.PulpitSubjects(@currPulpit) as varchar(300))
						end
						fetch pulpitCursor into @currPulpit
					end
				end
				fetch facultyCursor into @currFaculty

			end
			set @result = dbo.PulpitCount(@faculty)
			close pulpitCursor
		end
		else
		begin
			-- оба не null
			fetch facultyCursor into @currFaculty
			open pulpitCursor
			while @@FETCH_STATUS = 0
			begin		
					fetch pulpitCursor into @currPulpit
					while @@FETCH_STATUS = 0
					begin
						if(@currPulpit = @pulpit)
						begin
							print 'Факультет: ' + @currFaculty
							print char(9) + 'Кафедра ' + @currPulpit
							print char(9) +  char(9) + 'Количество учителей: ' +cast(dbo.TeacherCount(@currPulpit) as varchar(5))
							print char(9) +  char(9) + cast(dbo.PulpitSubjects(@currPulpit) as varchar(300))
							
						end
						fetch pulpitCursor into @currPulpit
					end
					fetch facultyCursor into @currFaculty
			end
			set @result = dbo.PulpitCount(@faculty)
			close pulpitCursor

		end
	end

	close facultyCursor
	return @result
end
go

declare @rez int
exec @rez = PFACULTY_REPORT2 
print '----------- ' + cast (@rez as nvarchar(10)) 
go
declare @rez int
exec @rez = PFACULTY_REPORT2 @faculty = 'ХТиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go
go
declare @rez int
exec @rez = PFACULTY_REPORT2 @pulpit = 'ИСиТ'
print '----------- ' + cast (@rez as nvarchar(10)) 
go
