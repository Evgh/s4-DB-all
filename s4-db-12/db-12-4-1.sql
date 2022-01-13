-- 12.4.1 -- ÓÐÎÂÍÈ ÈÇÎËßÖÈÈ ÒÐÀÍÇÀÊÖÈÉ, ÔÀÉË À

--READ-UNCOMMITED--------------------------------------------------------------------------------------------------------------------------
use E_Univer;
set transaction isolation level READ UNCOMMITTED;

begin transaction 

	select 'select Ñòóäåíòû'  'ðåçóëüòàò',  student.NAME from STUDENT  where IDSTUDENT > 1080;
-------------------------- t1 ------------------
	select 'update Ñòóäåíòû'  'ðåçóëüòàò',  student.NAME from STUDENT  where IDSTUDENT > 1080;
-------------------------- t2 -----------------
	select 'rollback Ñòóäåíòû'  'ðåçóëüòàò',  student.NAME from STUDENT  where IDSTUDENT > 1080;
	commit; 



--READ-COMMITED--------------------------------------------------------------------------------------------------------------------------
USE E_Univer;
set transaction isolation level READ COMMITTED ;

	insert into student(name) values ('readCommited1');

	begin transaction 
	select name from STUDENT where STUDENT.NAME Like 'readCommited%' 
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select name from STUDENT where STUDENT.NAME Like 'readCommited%'
	commit; 



--REPEATABLE-READ---------------------------------------------------------------------------------------------------------------------------

--insert into student(name) values ('repeatableRead'), ('repeatableRead1');

set transaction isolation level  REPEATABLE READ 
	begin transaction

	select count(*) from STUDENT where NAME like 'repeatableRead%'
	-------------------------- t1 ------------------ 
	-------------------------- t2 -----------------
	select count(*) from STUDENT where NAME like 'repeatableRead%'
	commit; 


--SERIALIZABLE-----------------------------------------------------------------------------------------------------------------------------
--insert into student(name) values ('repeatableRead'), ('repeatableRead1');

set transaction isolation level SERIALIZABLE 
	begin transaction
	update STUDENT set NAME = '!' + NAME where  STUDENT.NAME = 'repeatableRead'

	select count(*) from STUDENT where NAME like 'repeatableRead%'
	-------------------------- t1 ------------------ 
	
	begin transaction
	insert into STUDENT(name) values ('repeatableRead Phantom'); 
	select count(*) from STUDENT where NAME like 'repeatableRead%'
	commit; 
	
