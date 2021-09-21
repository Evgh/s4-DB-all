use E_Univer;

-- 1
use E_Univer;

drop function CountStudents;
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

-------------------------------
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


use E_Univer;
select * from Student inner join Groups on Student.IDGROUP = Groups.IDGROUP

print dbo.CountStudents('ИЭФ');
print dbo.CountStudents('ИЭФ','1-25 01 07');



----------------------------------------------------------------------------------------- 2
use E_Univer;

drop function PulpitSubjects;
go
create function PulpitSubjects(@pulpit varchar(20)) returns varchar(300)
as
begin
	declare @subjects varchar(300) = 'Дисциплины: ';
	declare @subject varchar(50);
	declare SubjectsCursor cursor local for
		select SUBJECT 
		from SUBJECT 
		where SUBJECT.PULPIT = @pulpit

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

print dbo.PulpitSubjects('ИСИТ');
select PULPIT, dbo.PulpitSubjects(PULPIT)[Дисциплины] from PULPIT

go


-------------------------------------------------------------------------------------- 3

drop function FacultyPulpit

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
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			return
		end
		else if (@pulpit is not null)
		begin
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
			insert into @result
			select FACULTY.FACULTY, PULPIT.PULPIT
			from FACULTY left outer join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY
			where FACULTY.FACULTY = @faculty
			return
		end
		else
		begin
			-- both not null
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

select * from FacultyPulpit(null, null)
select * from FacultyPulpit('ХТИТ', null)
select * from FacultyPulpit(null, 'ЛВ')
select * from FacultyPulpit('ЛХФ', 'ЛВ')

go


----------------------------------------------------------------- 4
USE E_Univer;
drop function TeacherCount;
go
create function TeacherCount(@pulpit char(20)) returns int
as
begin
	Declare @teacherCount int = 0

	if (@pulpit is null)
		set @teacherCount = (select count(*) from TEACHER)
	else
		set @teacherCount = (select count(*) from TEACHER where PULPIT = @pulpit)

	return @teacherCount
end
go

select PULPIT, dbo.TeacherCount(PULPIT) from PULPIT group by rollup (pulpit.PULPIT)
select dbo.TeacherCount(NULL)
go


----------------------------------------------------------------------------------------- 5
use KASPER_MyNewBase;

drop function CountPassedStudents;
go
create function CountPassedStudents(@discipline nvarchar(5)) returns int
as 
begin 
	return (select count(*) from CREDITS where discipline_code = @discipline);
end 
go

drop function GetBesties
go 
create function GetBesties() returns @besties table( [Предмет] nvarchar(50), [Количество сдавших] int, [Лучшая оценка] int, [Фамилия лучшего] nvarchar(15))
as 
begin
	
	insert into @besties 
	SELECT DISCIPLINES.discipline_name [Предмет], dbo.CountPassedStudents(DISCIPLINES.discipline_code), CREDITS.credit_mark [Оценка], STUDENTS.student_name [Студент] 
		FROM CREDITS join STUDENTS on CREDITS.student_id = STUDENTS.student_id
				join DISCIPLINES on DISCIPLINES.discipline_code = CREDITS.discipline_code
		WHERE STUDENTS.student_id in 
				(SELECT top(1) student_id 
					FROM CREDITS 
					WHERE CREDITS.discipline_code = DISCIPLINES.discipline_code 
					ORDER BY credit_mark desc);
	return 
end
go 

select * from GetBesties();



----------------------------------------------------------------- 6
use E_Univer
drop function StudentCount;
go
create function StudentCount(@faculty varchar(50)) returns int
as
begin

	return (select count(*)
			from STUDENT inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
					 inner join FACULTY on GROUPS.FACULTY = FACULTY.FACULTY
			where FACULTY.FACULTY = @faculty)
end
go

drop function PulpitCount;
go
create function PulpitCount(@faculty varchar(50)) returns int
as
begin
	return (select count(*)
			from PULPIT
			where PULPIT.FACULTY = @faculty)
end
go

drop function ProfessionCount;
go
create function ProfessionCount(@faculty varchar(50)) returns int
as
begin
	return (select count(*)
			from PROFESSION
			where PROFESSION.FACULTY = @faculty)
end
go

drop function GroupCount;
go
create function GroupCount(@faculty varchar(50)) returns int
as
begin
	return (select count(*)
			from GROUPS
			where GROUPS.FACULTY = @faculty)
end
go


alter function FacultyReport(@studentCount int) 
returns @result table 
		(
			[Факультет] varchar(50),
			[Количество кафедр] int, 
			[Количество групп] int, 
			[Количество студентов] int,
			[Количество специальностей] int
		)
as
begin
	declare FacultyCursor cursor local for select FACULTY from FACULTY where dbo.StudentCount(FACULTY) > @studentCount
	declare @faculty varchar(50)

	open FacultyCursor
		fetch FacultyCursor into @faculty
		while @@FETCH_STATUS = 0
		begin
			insert into @result values
			(@faculty, dbo.PulpitCount(@faculty), dbo.GroupCount(@faculty), dbo.StudentCount(@faculty), dbo.ProfessionCount(@faculty))

			fetch FacultyCursor into @faculty
		end

	close FacultyCursor
	return
end
go

select * from dbo.FacultyReport(1)

-- 7
go
alter procedure PFACULTY_REPORT2 @faculty char(10) = null, @pulpit char(10) = null as
begin
	declare facultyCursor cursor local for select faculty from FACULTY
	declare pulpitCursor cursor local for select pulpit from PULPIT
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
						print char(9) +  char(9) + 'Количество учителей: ' + cast(dbo.TeacherCount(@currPulpit) as varchar(5))
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
			-- faculty null, pulpit not null
			fetch facultyCursor into @currFaculty
			
			set @currFaculty = (select FACULTY.FACULTY from FACULTY join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY where PULPIT.PULPIT = @pulpit);
			
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
print '--------------------------------------------------------------------------------------- '
print '----------- ' + cast (@rez as nvarchar(10)) 

go
declare @rez int
exec @rez = PFACULTY_REPORT2 @faculty = 'ИТ'
print '--------------------------------------------------------------------------------------- '
print '----------- ' + cast (@rez as nvarchar(10)) 
go

go
declare @rez int
exec @rez = PFACULTY_REPORT2 @pulpit = 'ОХ'
print '--------------------------------------------------------------------------------------- '

print '----------- ' + cast (@rez as nvarchar(10)) 
go
