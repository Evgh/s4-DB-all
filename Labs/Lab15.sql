use UniversityLab4
	
-- 1 - 4 �������� �� Insert, delete, update + ����� ��� TEACHER
create table TR_AUDIT
(
ID int primary key identity, 
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)

go
alter trigger TR_TEACHER_INS on TEACHER after INSERT as
declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)
set @ID = RTRIM((select TEACHER from INSERTED))
set @NAME = (select TEACHER_NAME from INSERTED)
set @GENDER = (select GENDER from INSERTED)
set @PULPIT = RTRIM((select PULPIT from INSERTED))

if(@GENDER not in ('�', '�'))
begin
	raiserror('��� ������ �������', 10,1)
	rollback
end

set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
insert into TR_AUDIT values ('INS', 'TR_TEACHER_INS', @RESULT)
go

go
alter trigger TR_TEACHER_DEL on TEACHER after DELETE as
declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)
set @ID = RTRIM((select TEACHER from DELETED))
set @NAME = (select TEACHER_NAME from DELETED)
set @GENDER = (select GENDER from DELETED)
set @PULPIT = RTRIM((select PULPIT from DELETED))
set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL', @RESULT)
go

go
alter trigger TR_TEACHER_UPD on TEACHER after UPDATE as
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


go
alter trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE as
declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @OPERATION char(3), @RESULT varchar(300)
if ((select count(*) from DELETED) > 0)
begin
	set @ID = RTRIM((select TEACHER from DELETED))
	set @NAME = (select TEACHER_NAME from DELETED)
	set @GENDER = (select GENDER from DELETED)
	set @PULPIT = RTRIM((select PULPIT from DELETED))
	set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
	set @OPERATION = 'DEL'
END
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
return;
go


insert into TEACHER
values ('����', '�������� ����� ������������', '�', '����')
update TEACHER set TEACHER = '�����' where TEACHER = '����' 
delete from TEACHER where TEACHER = '�����'


select * from TR_AUDIT

delete from TR_AUDIT
--

-- 5 - �������� ������������ ����������� �� ��������

insert into TEACHER
values ('����', '�������� ����� ������������', '�', '����')
insert into TEACHER
values ('����', '�������� ����� ������������', '�', '����')
insert into TEACHER
values ('����', '�������� ����� ������������', '�', '����')
delete from TEACHER where TEACHER = '����'
select * from TR_AUDIT


-- 6-7 - ������� ���������� ���������
go
alter trigger TR_TEACHER_DEL_B on TEACHER after DELETE as
declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)
set @ID = RTRIM((select TEACHER from DELETED))
set @NAME = (select TEACHER_NAME from DELETED)
set @GENDER = (select GENDER from DELETED)
set @PULPIT = RTRIM((select PULPIT from DELETED))
set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL_B', @RESULT)
go

go
alter trigger TR_TEACHER_DEL_C on TEACHER after DELETE as
declare @ID varchar(10), @NAME varchar(50), @GENDER char(1), @PULPIT varchar(15), @RESULT varchar(300)
set @ID = RTRIM((select TEACHER from DELETED))
set @NAME = (select TEACHER_NAME from DELETED)
set @GENDER = (select GENDER from DELETED)
set @PULPIT = RTRIM((select PULPIT from DELETED))
set @RESULT = @ID + ' ' + @NAME + ' ' + @GENDER + ' ' + @PULPIT
insert into TR_AUDIT values ('DEL', 'TR_TEACHER_DEL_C', @RESULT)
go


select t.name, e.type_desc 
from sys.triggers  t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE' ;  

exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL', @order = 'LAST', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL_B', @order = 'LAST', @stmttype = 'DELETE'
exec sp_settriggerorder @triggername = 'TR_TEACHER_DEL_C', @order = 'FIRST', @stmttype = 'DELETE'

-- 7 -- ������� - ����� ����������

insert into TEACHER values ('����', '�������� ����� ������������', '�', '����')
select * from TEACHER where TEACHER = '����'

-- 8 -- insteadof
go
alter trigger TR_FACULTY_DELETE on FACULTY instead of DELETE
as
raiserror('�������� ���������', 10,1)
go
select * from FACULTY
delete from faculty where FACULTY = '���'


-- drop trigger TR_FACULTY_DELETE

-- drop trigger TR_TEACHER
-- drop trigger TR_TEACHER_DEL
-- drop trigger TR_TEACHER_DEL_B
-- drop trigger TR_TEACHER_DEL_C
-- drop trigger TR_TEACHER_INS
-- drop trigger TR_TEACHER_UPD

-- 9 DB TRIGGER
go
alter trigger TR_UNIVERSITY on database for CREATE_TABLE, DROP_TABLE, ALTER_TABLE as
declare @t1 varchar(50), @t2 varchar(50), @t3 varchar(50) 
set @t1 = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)')
set @t2 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','varchar(50)')
set @t3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','varchar(50)')

print '��� �������: ' + @t1;
print '��� �������: ' + @t2;
print '��� �������: ' + @t3;

raiserror('�������� �������� � �������� ������ ���������',10,1)
rollback

return
go


create table NewTable
(
id int primary key,
val varchar(300)
)
select * from NewTable
drop table NewTable

-- 10 MyBase
select * from [���������� ������]
use Lab2
go
create table TR_AUDIT
(
ID int primary key identity, 
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)
go
alter trigger TR_Reports on [���������� ������] for INSERT, UPDATE, DELETE as
declare @ID int, @NAME varchar(50), @DATE DATETIME, @FACTORNAME varchar(50), @FACTORVALUE int, @RESULT varchar(300), @OPERATION varchar(3)
if ((select count(*) from DELETED) > 0)
begin
	set @ID = (select ����� from DELETED)
	set @NAME = RTRIM((select ��������_����������� from DELETED))
	set @DATE = (select ���� from DELETED)
	set @FACTORNAME = RTRIM((select ��������_���������� from DELETED))
	set @FACTORVALUE = (select ��������_���������� from DELETED)
	set @RESULT = cast(@ID as varchar(50)) + ' ' + @NAME + ' ' + cast(@DATE as varchar(30)) + ' ' + @FACTORNAME + ' ' + cast(@FACTORVALUE as varchar(50))
	set @OPERATION = 'DEL'
END
if ((select count(*) from INSERTED) > 0)
begin
	set @ID = (select ����� from INSERTED)
	set @NAME = RTRIM((select ��������_����������� from INSERTED))
	set @DATE = (select ���� from INSERTED)
	set @FACTORNAME = RTRIM((select ��������_���������� from INSERTED))
	set @FACTORVALUE = (select ��������_���������� from INSERTED)

	set @OPERATION = 'DEL'
	if ((select count(*) from DELETED) > 0)
	begin
		set @RESULT = @RESULT +  '-- ' +  cast(@ID as varchar(50)) + ' ' + @NAME + ' ' + cast(@DATE as varchar(30)) + ' ' + @FACTORNAME + ' ' + cast(@FACTORVALUE as varchar(50))
		set @OPERATION = 'UPD'
	end
	else 
	begin
		set @RESULT =  cast(@ID as varchar(50)) + ' ' + @NAME + ' ' + cast(@DATE as varchar(30)) + ' ' + @FACTORNAME + ' ' + cast(@FACTORVALUE as varchar(50))
		set @OPERATION = 'INS'
	end
end
insert into TR_AUDIT values (@OPERATION, 'TR_REPORTS', @RESULT)
return
go

select * from [���������� ������]
select * from TR_AUDIT
insert into [���������� ������] values 
(346, '��������_������', '20210518', '�������', 20000)
update [���������� ������] set ��������_���������� = 23748 where ��������_����������� = '��������_������'
delete from [���������� ������]  where ��������_����������� = '��������_������'
go


-- 11

use RANDOM
create table TR_AUDIT
(
ID int primary key identity, 
STMT varchar(20) check (STMT in ('INS', 'DEL', 'UPD')),
TRNAME varchar(50),
CC varchar(300)
)
create table WEATHER
(
CITY varchar(30),
STARTDATE DATETIME,
ENDDATE DATETIME,
TEMP NUMERIC
)
go
alter trigger TR_WEATHER ON WEATHER FOR INSERT, UPDATE as
declare @CITY varchar(30), @STARTDATE DATETIME, @ENDDATE DATETIME, @TEMP NUMERIC, @ERROR varchar(300)

SET @CITY = (select CITY from inserted)
SET @STARTDATE = (select STARTDATE from inserted)
SET @ENDDATE = (select ENDDATE from inserted)
SET @TEMP = (select TEMP from inserted)

if (exists 
(select * from WEATHER where (STARTDATE >= @STARTDATE AND STARTDATE <= @ENDDATE) OR (ENDDATE >= @STARTDATE AND ENDDATE <= @ENDDATE) 
except select * from INSERTED))
begin
	SET @ERROR = '�� ������� �������� ' + @CITY + ' ' + cast(@STARTDATE as varchar(20)) + ' ' + 
	cast(@ENDDATE as varchar(20)) + ' ' + cast(@TEMP as varchar(10)) + ' - ������ �� ������ ���������� ������� ��� ����������' 

	raiserror(@ERROR, 10, 1)
	rollback
end
return
go

select * from WEATHER
delete from WEATHER
insert into WEATHER values
('�����', '20210101 12:00', '20210101 23:59', 13)
insert into WEATHER values
('�����', '20210101 00:00', '20210101 11:59', 7)
insert into WEATHER values
('�����', '20210101 00:00', '20210101 02:00', 7)
go

