USE E_Univer;
---------------------------------------------------------------------- primary
------Создание и заполнение таблицы FACULTY
create table FACULTY
(
	FACULTY char(10) constraint FACULTY_PK primary key,
	FACULTY_NAME varchar(50) default '???'
);

------------Создание и заполнение таблицы AUDITORIUM_TYPE 
create table AUDITORIUM_TYPE 
(    
	AUDITORIUM_TYPE char(10) constraint AUDITORIUM_TYPE_PK primary key,  
	AUDITORIUM_TYPENAME varchar(30)       
) 

------Создание и заполнение таблицы PROFESSION
create table PROFESSION
(   
	PROFESSION char(20) constraint PROFESSION_PK  primary key,
    FACULTY char(10) constraint PROFESSION_FACULTY_FK foreign key 
			references FACULTY(FACULTY),
    PROFESSION_NAME varchar(100), QUALIFICATION varchar(50)  
);  


---------------------------------------------------------------------- G1
------Создание и заполнение таблицы PULPIT
create table  PULPIT 
(   
	PULPIT   char(20)  constraint PULPIT_PK  primary key,
    PULPIT_NAME  varchar(100), 
    FACULTY   char(10) constraint PULPIT_FACULTY_FK foreign key 
			references FACULTY(FACULTY) 
) on G1  

------Создание и заполнение таблицы SUBJECT
create table SUBJECT
(     
	SUBJECT  char(10) constraint SUBJECT_PK  primary key, 
	SUBJECT_NAME varchar(100) unique,
	PULPIT  char(20) constraint SUBJECT_PULPIT_FK foreign key 
			references PULPIT(PULPIT)   
) on G1

------Создание и заполнение таблицы GROUPS
create table GROUPS 
(   
	IDGROUP  integer  identity(1,1) constraint GROUP_PK  primary key,              
	FACULTY   char(10) constraint  GROUPS_FACULTY_FK foreign key 
			references FACULTY(FACULTY), 
	PROFESSION  char(20) constraint  GROUPS_PROFESSION_FK foreign key 
			references PROFESSION(PROFESSION),
	YEAR_FIRST  smallint  check (YEAR_FIRST<=YEAR(GETDATE())),                  
) on G1

------Создание и заполнение таблицы TEACHER
 create table TEACHER
(   
	TEACHER    char(10)  constraint TEACHER_PK  primary key,
	TEACHER_NAME  varchar(100), 
	GENDER     char(1) CHECK (GENDER in ('м', 'ж')),
	PULPIT   char(20) constraint TEACHER_PULPIT_FK foreign key 
			references PULPIT(PULPIT) 
) on G1


---------------------------------------------------------------------- G2
-------------Создание и заполнение таблицы AUDITORIUM  
create table AUDITORIUM 
(   
	AUDITORIUM   char(20)  constraint AUDITORIUM_PK  primary key,              
    AUDITORIUM_TYPE     char(10) constraint  AUDITORIUM_AUDITORIUM_TYPE_FK foreign key 
			references AUDITORIUM_TYPE(AUDITORIUM_TYPE), 
	AUDITORIUM_CAPACITY  integer constraint  AUDITORIUM_CAPACITY_CHECK default 1 check (AUDITORIUM_CAPACITY between 1 and 300),  -- вместимость 
	AUDITORIUM_NAME      varchar(50)                                     
) on G2

------Создание и заполнение таблицы STUDENT
create table STUDENT 
(    
	IDSTUDENT   integer  identity(1000,1) constraint STUDENT_PK  primary key,
	IDGROUP   integer  constraint STUDENT_GROUP_FK foreign key
			references GROUPS(IDGROUP),        
	NAME   nvarchar(100), 
	BDAY   date,
	STAMP  timestamp,
	INFO     xml,
	FOTO     varbinary
) on G2

------Создание и заполнение таблицы PROGRESS
create table PROGRESS
(  
	SUBJECT   char(10) constraint PROGRESS_SUBJECT_FK foreign key
			references SUBJECT(SUBJECT),                
	IDSTUDENT integer  constraint PROGRESS_IDSTUDENT_FK foreign key         
			references STUDENT(IDSTUDENT),        
	PDATE    date, 
	NOTE     integer check (NOTE between 1 and 10)
) on G2