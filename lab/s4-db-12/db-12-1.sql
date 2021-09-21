USE E_Univer;

set nocount on
if  exists (select * from  SYS.OBJECTS        -- ������� X ����?
            where OBJECT_ID= object_id(N'DBO.TASK1') )	            
drop table TASK1;   

declare @c int, @flag char = 'r';           -- commit ��� rollback?

SET IMPLICIT_TRANSACTIONS  ON   -- �����. ����� ������� ����������

CREATE table TASK1(id int, word varchar(10));                         -- ������ ���������� 

	INSERT TASK1 values (1, 'first'), (2, 'second'),(3, 'third');
	set @c = (select count(*) from TASK1);
	print '���������� ����� � �������: ' + cast( @c as varchar(2));

	if @flag = 'c'  commit;                   -- ���������� ����������: �������� 
          else   rollback;                                 -- ���������� ����������: �����  

  SET IMPLICIT_TRANSACTIONS  OFF   -- ������. ����� ������� ����������


if  exists (select * from  SYS.OBJECTS       -- ������� X ����?
            where OBJECT_ID= object_id(N'DBO.TASK1'))
print '������� TASK1 ����';  
  else print '������� TASK1 ���'


-- 2 
use E_Univer;
begin try

	begin tran 
	update STUDENT set name = 'Atomarity';
	select * from student;
	delete FACULTY where FACULTY = '��';
	commit tran

end try 
begin catch

	print error_number();
	print error_message();
	rollback tran;

end catch
select * from student;
select * from FACULTY where FACULTY = '��';

-- 3
use E_Univer;
declare @point varchar(5);

select * from STUDENT

begin try
	
	begin tran 
		update STUDENT set name = student.NAME + '1' where IDGROUP = 1;
		set @point = 'p1'; save tran @point;

		insert into STUDENT (IDSTUDENT, IDGROUP, NAME) values (1, 1, 'Blob');
		set @point = 'p2'; save tran @point;
	commit tran 

end try
begin catch 
	print error_message();

	if @@TRANCOUNT > 0 
		begin
			
			print 'check point: ' + @point;
			rollback tran @point;
			commit tran

		end 
end catch

select * from STUDENT; 

-- 8 (��������� ����������)
use E_Univer;

select count(*) from STUDENT where name = '�������';

begin tran

	begin tran 
		insert into STUDENT(name) values ('�������');
		select count(*) from STUDENT where name = '�������';
	commit tran 

	if @@TRANCOUNT > 0 
		rollback tran  -- rollback ������� ���������� �������� ��� ������� ����������

select count(*) from STUDENT where name = '�������';



-- 9
use KASPER_MyNewBase

select * from STUDENTS;

begin tran 
	
	begin tran 
		update students set student_name = '����, ���� 12';
	commit tran

	select * from STUDENTS

if @@TRANCOUNT > 0 
	rollback tran

select * from STUDENTS


-- 10 
-- Serializable