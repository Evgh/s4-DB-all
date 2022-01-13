USE KASPER_MyBase;
--Select *from СТУДЕНТЫ;
--Select *from ЗАЧЕТЫ;
INSERT into СТУДЕНТЫ (Номер_студенческого, Фамилия) values (000000, 'Knyazeva'), (666666, 'Pleshkova');
Select top(3) *from СТУДЕНТЫ ;

--USE KASPER_MyBase;
DELETE FROM СТУДЕНТЫ where Фамилия = 'Knyazeva' or Фамилия = 'Pleshkova';
Select *from СТУДЕНТЫ;