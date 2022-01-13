use E_Univer
	
-- 1 - 4 триггеры на Insert, delete, update + общий для TEACHER
drop table TR_AUDIT;
create table TR_AUDIT
(
	ID int primary key identity, 
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)

drop trigger TR_TEACHER_INS;
go
create trigger TR_TEACHER_INS on TEACHER after INSERT 
as
begin
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from INSERTED))
	set @NAME = (select TEACHER_NAME from INSERTED)
	set @GENDER = (select GENDER from INSERTED)
	set @PULPIT = RTRIM((select PULPIT from INSERTED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('INS', 'TR_TEACHER_INS', @RESULT)

	if(@PULPIT not in (select pulpit from pulpit))
	begin
		raiserror('Такой кафедры не существует', 10,1)
		rollback
	end

	if(@ID = 'ПНЧНК')
	begin
		raiserror('Она вне игры', 10,1)
		rollback
	end
end
go

drop trigger TR_TEACHER_DEL;
go
create trigger TR_TEACHER_DEL on TEACHER after DELETE 
as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL', @RESULT)
go

drop trigger TR_TEACHER_UPD;
go
create trigger TR_TEACHER_UPD on TEACHER after UPDATE as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT + ' -- '

	set @ID = RTRIM((select TEACHER from INSERTED))
	set @NAME = (select TEACHER_NAME from INSERTED)
	set @GENDER = (select GENDER from INSERTED)
	set @PULPIT = RTRIM((select PULPIT from INSERTED))
	set @RESULT = @RESULT + @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('UPD', 'TR_TEACHER_UPD', @RESULT)
go

drop trigger TR_TEACHER;
go
create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE 
as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @OPERATION char(3), @RESULT varchar(300)
	if ((select count(*) from DELETED) > 0)
	begin
		set @ID = RTRIM((select TEACHER from DELETED))
		set @NAME = (select TEACHER_NAME from DELETED)
		set @GENDER = (select GENDER from DELETED)
		set @PULPIT = RTRIM((select PULPIT from DELETED))
		set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
		set @OPERATION = 'DEL'
	end

	if ((select count(*) from INSERTED) > 0)
	begin
		set @ID = RTRIM((select TEACHER from INSERTED))
		set @NAME = (select TEACHER_NAME from INSERTED)
		set @GENDER = (select GENDER from INSERTED)
		set @PULPIT = RTRIM((select PULPIT from INSERTED))
		
		if ((select count(*) from DELETED) > 0)
		begin
			set @RESULT = @RESULT +  '-- ' +  @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
			set @OPERATION = 'UPD'
		end
		else 
		begin
			set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
			set @OPERATION = 'INS'
		end
	end

	insert into TR_AUDIT values (@OPERATION, 'TR_TEACHER', @RESULT)
go


insert into TEACHER
values ('СХРКВ', 'Сухорукова Елена Владимировна', 'ж', 'ИСиТ')
update TEACHER set TEACHER = 'СХРКВ' where TEACHER = 'СХРКВ' 
delete from TEACHER where TEACHER = 'СХРКВ'

select * from TR_AUDIT

delete from TR_AUDIT


-------------------------------------------------- 5
begin try
	begin tran
	insert into TEACHER values ('КОТИК', 'Воюш Инга Дмитриевна', 'ж', 'Медиа');
	commit tran
end try
begin catch
	print error_message();
	rollback tran
end catch

---------------------------------------------------- 6
-- 6-7 - порядок выполнения триггеров
drop trigger TR_TEACHER_DEL1;
go
create trigger TR_TEACHER_DEL1 on TEACHER after DELETE 
as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL1', @RESULT)
go

drop trigger TR_TEACHER_DEL2;
go
create trigger TR_TEACHER_DEL2 on TEACHER after DELETE 
as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL2', @RESULT)
go

drop trigger TR_TEACHER_DEL3;
go
create trigger TR_TEACHER_DEL3 on TEACHER after DELETE 
as
	declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)

	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT

	insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL3', @RESULT)
go


select t.name, e.type_desc 
from sys.triggers  t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;  

exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL', @order = 'None', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL1', @order = 'None', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL2', @order = 'LAST', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL3', @order = 'FIRST', @stmttype = 'DELETE'

---------------------------------------- 7 
begin try 
	begin tran 
	insert into TEACHER values ('ПНЧНК', 'Панченко Ольга Леонидовна', 'ж', 'ИСиТ');
end try 
begin catch
	print error_message();
end catch 
if @@TRANCOUNT > 0
	commit tran

select * from TEACHER where TEACHER = 'ПНЧНК';


----------------------------------------- 8
use E_Univer;

drop trigger TR_FACULTY_DELETE;
go
create trigger TR_FACULTY_DELETE on FACULTY instead of DELETE
as
raiserror('Удаление запрещено', 10,1)
go

go
create trigger TR_FACULTY_INSERT on FACULTY instead of INSERT
as
begin
	declare @f char(10) = (select FACULTY from inserted);
	declare @n varchar(50) = (select FACULTY_NAME from inserted) 
	if (@f is null)
		raiserror('Несоответствие ограничениям целостности', 10, 1);
	else 
		insert into FACULTY values (@f, @n);
end 
go

delete from faculty where FACULTY = 'АН'
select * from FACULTY


begin tran 
	insert into FACULTY(FACULTY, FACULTY_NAME) values ('A', null);	
	insert into FACULTY(FACULTY, FACULTY_NAME) values (null, null);	
	select * from FACULTY;
rollback tran

drop trigger TR_FACULTY_DELETE
drop trigger TR_FACULTY_INSERT;
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3
drop trigger TR_TEACHER_INS
drop trigger TR_TEACHER_UPD
------------------------------------------ 9 

go
create trigger TR_UNIVERSITY on database for CREATE_TABLE, DROP_TABLE, ALTER_TABLE 
as
	declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50) 
	set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
	set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)')
	set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')

	print 'Тип события: ' + @t1;
	print 'Имя объекта: ' + @t2;
	print 'Тип объекта: ' + @t3;

	if (@t1 = 'DROP_TABLE' or @t1 = 'CREATE_TABLE')
	begin
		raiserror('Операции удаления и создания таблиц запрещены',10,1)
		rollback
	end
return
go


create table NewTable
(
	id int primary key,
	val varchar(300)
)

drop table PROGRESS


--------------------------------------------- 10
use KASPER_MyNewBase

create table #TR_DML_AYDIT 
(
	ID int primary key identity, 
	STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
	TRNAME varchar(50),
	CC varchar(300)
)

drop trigger TR_CREDITS_DML
go
alter trigger TR_CREDITS_DML on CREDITS after INSERT, DELETE, UPDATE 
as
	declare @ID int, @DISCIPLINE varchar(5), @STUDENT nchar(7), @CREDIT int, @RESULT varchar(300), @OPERATION char(3);

	if ((select count(*) from DELETED) > 0)
	begin
		set @ID = (select credit_id from DELETED)
		set @DISCIPLINE = (select discipline_code from DELETED)
		set @STUDENT = (select student_id from DELETED)
		set @CREDIT = (select credit_mark from DELETED)
		
		set @RESULT = cast(@ID as varchar(5)) + ' ' + @DISCIPLINE + ' ' + cast(@STUDENT as varchar(7)) + ' ' + cast(@CREDIT as char)
		set @OPERATION = 'DEL'
	end

	if ((select count(*) from INSERTED) > 0)
	begin
		set @ID = (select credit_id from INSERTED)
		set @DISCIPLINE = (select discipline_code from INSERTED)
		set @STUDENT = (select student_id from INSERTED)
		set @CREDIT = (select credit_mark from INSERTED)
		
		if ((select count(*) from DELETED) > 0)
		begin
			set @RESULT = @RESULT +  '-- ' + cast(@ID as varchar(5)) + ' ' + @DISCIPLINE + ' ' + cast(@STUDENT as varchar(7)) + ' ' + cast(@CREDIT as char)
			set @OPERATION = 'UPD'
		end
		else 
		begin
			set @RESULT = cast(@ID as varchar(5)) + ' ' + @DISCIPLINE + ' ' + cast(@STUDENT as varchar(7)) + ' ' + cast(@CREDIT as char)
			set @OPERATION = 'INS'
		end
	end

	insert into #TR_DML_AYDIT values (@OPERATION, 'TR_CREDITS_DML', @RESULT)

drop trigger TR_CREDITS_DDL
go 
create trigger TR_CREDITS_DDL on database for CREATE_TABLE, DROP_TABLE, ALTER_TABLE 
as 
begin
	declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50) 
	set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
	set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)')
	set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')

	print 'Тип события: ' + @t1;
	print 'Имя объекта: ' + @t2;
	print 'Тип объекта: ' + @t3;
end
go

insert into CREDITS(discipline_code, student_id, credit_mark) values ('БД', '0000001', 3);
delete from CREDITS where credit_mark = 3;

select * from #TR_DML_AYDIT;
delete from #TR_DML_AYDIT;

create table Temp ( temp int );
drop table Temp;


--------------------------------------------- 11 
--create database WeatherDB;
use WeatherDB;

create table TR_AUDIT
(
ID int primary key identity, 
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)

drop table Weather;
create table WEATHER
(
CITY varchar(30),
STARTDATE DATETIME,
ENDDATE DATETIME,
TEMP NUMERIC
)

go
create trigger TR_WEATHER ON WEATHER FOR INSERT, UPDATE 
as
	declare @CITY varchar(30), @STARTDATE DATETIME, @ENDDATE DATETIME, @TEMP NUMERIC, @ERROR varchar(300)

	SET @CITY = (select CITY from inserted)
	SET @STARTDATE = (select STARTDATE from inserted)
	SET @ENDDATE = (select ENDDATE from inserted)
	SET @TEMP = (select TEMP from inserted)

	if (exists 
	(select * from WEATHER where 
		(STARTDATE >= @STARTDATE AND STARTDATE <= @ENDDATE) OR (ENDDATE >= @STARTDATE AND ENDDATE <= @ENDDATE)
		except select * from INSERTED))
	begin
		SET @ERROR = 'Не удалось вставить ' + @CITY + ' ' + cast(@STARTDATE as varchar(20)) + ' ' + 
		cast(@ENDDATE as varchar(20)) + ' ' + cast(@TEMP as varchar(10)) + ' - данные на данный промежуток времени уже существуют' 
		raiserror(@ERROR, 10, 1)
		rollback
	end
	return
go

delete from WEATHER
insert into WEATHER values
('Питер', '20210101 12:00', '20210101 23:59', 13)
insert into WEATHER values
('Питер', '20210101 00:00', '20210101 11:59', 7)
insert into WEATHER values
('Питер', '20210101 00:00', '20210101 2:00', 7)

select * from WEATHER
go
