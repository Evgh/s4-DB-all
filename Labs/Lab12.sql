use UniversityLab4

-- task 1

SET IMPLICIT_TRANSACTIONS ON

Create table #temp
(
field int
)
insert into #temp values
(0),
(2),
(3),
(4),
(5)
commit

select * from #temp
Drop table #temp



SET IMPLICIT_TRANSACTIONS OFF

-- task 2-3


begin try
	begin tran

		Create table #temp
		(
			field int primary key
		)

		insert into #temp values
		(0),
		(1)

		save tran savepoint1


		insert into #temp values
		(0),
		(0),
		(1)
		select * from #temp

		drop table #temp
		commit tran

end try
begin catch
	
	print 'Error ' + error_message()
	rollback tran savepoint1
	select * from #temp
	drop table #temp 
	

end catch

--task 4

use tempdb
Create table ##temp
		(
			field int 
		)

insert into ##temp values
(0),
(1),
(2)

set transaction isolation level read uncommitted
begin tran
	select @@SPID, * from ##temp
	begin tran
		delete ##temp where field = 1
		insert into ##temp values (3), (4)
		Update ##temp set field = 99
		select @@SPID, * from ##temp
	rollback
	select @@SPID, * from ##temp
commit

drop table ##temp

-- task 5

use tempdb
Create table ##temp
		(
			field int 
		)

insert into ##temp values
(0),
(1),
(2)

set transaction isolation level read committed
begin tran
	select @@SPID, * from ##temp
	begin tran
		delete ##temp where field = 1
		select @@SPID, * from ##temp
		insert into ##temp values (3), (4)
		Update ##temp set field = 99
	commit
	select @@SPID, * from ##temp
rollback

drop table ##temp

-- task 6

use tempdb
Create table ##temp
		(
			field int 
		)

insert into ##temp values
(0),
(1),
(2)

set transaction isolation level repeatable read
begin tran
	select @@SPID, * from ##temp
	begin tran
		insert into ##temp values (3), (4)
		delete ##temp where field = 1
		Update ##temp set field = 99
		select @@SPID, * from ##temp
	commit
	select @@SPID, * from ##temp
rollback

drop table ##temp

--task 7
use tempdb
Create table ##temp
		(
			field int 
		)

insert into ##temp values
(0),
(1),
(2)

set transaction isolation level serializable
begin tran
	DBCC USEROPTIONS
	select @@SPID, * from ##temp
	begin tran
		insert into ##temp values (3), (4)
		delete ##temp where field = 1
		Update ##temp set field = 99
		select @@SPID, * from ##temp
	commit
	select @@SPID, * from ##temp
rollback
drop table ##temp

-- task 8

use tempdb
Create table ##temp
		(
			field int 
		)

insert into ##temp values
(0),
(1),
(2)
begin tran
select @@trancount, field as outer_tran from ##temp

	insert into ##temp values (6),(7)
	
	begin tran
		select @@trancount, field as inner_tran from ##temp
		update ##temp set field = 99
	rollback
 
commit
select @@trancount, field as tran_result from ##temp
drop table ##temp


-- task 9

use Lab2
Declare @value int
begin tran
	update ZHILYAKREPORTS set Значение_показателя = Значение_показателя + 10
	set @value = (select Значение_показателя from ZHILYAKREPORTS where Название_показателя = 'Стоимость акций')
	if (@value > 34100)
	begin
		print('rolling back...')
		rollback
	end
	print('committing...')
commit
