-- 12.4.2 -- УРОВНИ ИЗОЛЯЦИИ ТРАНЗАКЦИЙ, ФАЙЛ Б

--READ-UNCOMMITED--------------------------------------------------------------------------------------------------------------------------
use E_Univer;
	begin transaction 
	update STUDENT set STUDENT.NAME  =  'СУБД' where IDSTUDENT > 1080; 
	insert into STUDENT (NAME) values ('Phantom'); 
-------------------------- t1 --------------------
-------------------------- t2 --------------------
rollback;


--READ-COMMITED--------------------------------------------------------------------------------------------------------------------------

-------------------------- t1 --------------------
begin transaction 	  
      update STUDENT set NAME = '!' + NAME where  STUDENT.NAME = 'readCommited1' 
      insert into student(name) values ('readCommited');
	  
	  --select name from STUDENT where STUDENT.NAME Like '!readCommited%'

-------------------------- t2 --------------------
      commit; 
	  


--REPEATABLE-READ---------------------------------------------------------------------------------------------------------------------------
begin transaction 	  
      update STUDENT set NAME = '!' + NAME where  STUDENT.NAME = 'repeatableRead' -- unrepeatable read не выполняется, транзакция зависает, пока выполняется другая
-------------------------- t1 --------------------
begin transaction 	  
      insert into STUDENT(name) values ('repeatableRead'); -- phantom read выполняется
      commit; 	
-------------------------- t2 --------------------


--SERIALIZABLE-----------------------------------------------------------------------------------------------------------------------------
begin transaction 	  
      update STUDENT set NAME = '!' + NAME where  STUDENT.NAME = 'repeatableRead'
	  commit; 
	  
-------------------------- t1 --------------------
begin transaction 	  
      insert into STUDENT(name) values ('repeatableRead Phantom'); 
      commit; 	