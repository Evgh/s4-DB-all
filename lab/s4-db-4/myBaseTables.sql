USE KASPER_MyNewBase;

--drop table dbo.DISCIPLINES;
--drop table dbo.STUDENTS;
--drop table dbo.CREDITS;

CREATE TABLE STUDENTS 
(
	student_id nchar(7) NOT NULL primary key,
	student_name nvarchar(15) NOT NULL,
	student_surname nvarchar (20) NOT NULL,
	student_adress nvarchar (30),
	student_phone nvarchar(12),
)

CREATE TABLE DISCIPLINES
(
	discipline_code nvarchar(5) NOT NULL primary key,
	discipline_name nvarchar(50) NOT NUll 
			constraint discipline_Name_Unique unique,
	discipline_lk int NOT NULL,
	discipline_lb int NOT NULL,
	discipline_pz int NOT NULL
)

CREATE TABLE CREDITS
(	
	credit_id int primary key identity (1, 1),
	discipline_code nvarchar(5) NOT NULL 
			foreign key references DISCIPLINES(discipline_code),
	student_id nchar(7) NOT NULL
			foreign key references STUDENTS(student_id),
	credit_mark int NOT NULL 
			constraint credit_mark_check check (credit_mark between 1 and 10)
) on G1