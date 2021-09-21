use UniversityLab4

-- 1 XML RAW ����
select RTRIM(TEACHER), TEACHER_NAME, GENDER
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where PULPIT.PULPIT = '����'
for xml RAW('�������������'),
root ('����'), 
elements

-- 2 XML AUTO Auditorium x AuditoriumTypes

select RTRIM(AUDITORIUM), AUDITORIUM_TYPENAME, AUDITORIUM_CAPACITY
from AUDITORIUM inner join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM_TYPE.AUDITORIUM_TYPE LIKE '%��%'
for xml AUTO,
root('LECTURE_AUDITORIUMS'),
elements

-- 3 insert subjects from xml
begin tran
declare @xmlHandle int = 0,
      @xml varchar(2000) = '<?xml version="1.0" encoding="windows-1251" ?>
					<SUBJECTS> 
						<SUBJECT SUBJECT="����" SUBJECT_NAME="������������ ��������� � �������" PULPIT="����" /> 
						<SUBJECT SUBJECT="����" SUBJECT_NAME="���������� ��������� � �������" PULPIT="��" /> 
						<SUBJECT SUBJECT="����" SUBJECT_NAME="��������������� ��������� � �������" PULPIT="��"  />  
					</SUBJECTS>'

exec sp_xml_preparedocument @xmlHandle output, @xml
select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20))       
insert into SUBJECTS select * from openxml(@xmlHandle, '/SUBJECTS/SUBJECT', 0)
	with(SUBJECT char(10), SUBJECT_NAME varchar(100), PULPIT char(20)) 
select * from SUBJECTS where SUBJECT LIKE '%��'
exec sp_xml_removedocument @xmlHandle                 

rollback 

select * from STUDENT
-- 4 insert/update with xml - passport 

create table PASSPORTS
(
STUDENT int primary key foreign key references STUDENT(IDSTUDENT),
PASSPORT xml
)
begin tran

insert into PASSPORTS values
(1000, '<PASSPORT><SERIES>MP</SERIES><NUMBER>00001</NUMBER><ADDRESS><CITY>�����</CITY><STREET>������������</STREET><NUMBER>23</NUMBER></ADDRESS><ORGANIZATION>����������� ����</ORGANIZATION><STARTDATE>2021-01-01</STARTDATE></PASSPORT>'),
(1001, '<PASSPORT><SERIES>MP</SERIES><NUMBER>00002</NUMBER><ADDRESS><CITY>�����</CITY><STREET>������������</STREET><NUMBER>25</NUMBER></ADDRESS><ORGANIZATION>����������� ����</ORGANIZATION><STARTDATE>2021-02-04</STARTDATE></PASSPORT>'),
(1002, '<PASSPORT><SERIES>MP</SERIES><NUMBER>00003</NUMBER><ADDRESS><CITY>�����</CITY><STREET>������������</STREET><NUMBER>27</NUMBER></ADDRESS><ORGANIZATION>����������� ����</ORGANIZATION><STARTDATE>2021-01-12</STARTDATE></PASSPORT>')


select 
	STUDENT.NAME, 
	PASSPORT.value('(/PASSPORT/SERIES)[1]', 'varchar(10)') SERIES,
	PASSPORT.value('(/PASSPORT/NUMBER)[1]', 'varchar(10)') NUMBER,
	PASSPORT.value('(/PASSPORT/ORGANIZATION)[1]', 'varchar(100)') ORGANIZATION,
	PASSPORT.value('(/PASSPORT/STARTDATE)[1]', 'DATE') DATE,
	PASSPORT.query('/PASSPORT/ADDRESS') ADDRESS
from PASSPORTS inner join STUDENT on PASSPORTS.STUDENT = STUDENT.IDSTUDENT

update PASSPORTS
	set PASSPORT =  '<PASSPORT><SERIES>MP</SERIES><NUMBER>00003</NUMBER><ADDRESS><CITY>�����</CITY><STREET>�����������</STREET><NUMBER>27</NUMBER></ADDRESS><ORGANIZATION>����������� ����</ORGANIZATION><STARTDATE>2021-01-12</STARTDATE></PASSPORT>'
	where STUDENT = 1000

select 
	STUDENT.NAME, 
	PASSPORT.value('(/PASSPORT/SERIES)[1]', 'varchar(10)') SERIES,
	PASSPORT.value('(/PASSPORT/NUMBER)[1]', 'varchar(10)') NUMBER,
	PASSPORT.value('(/PASSPORT/ORGANIZATION)[1]', 'varchar(100)') ORGANIZATION,
	PASSPORT.value('(/PASSPORT/STARTDATE)[1]', 'DATE') DATE,
	PASSPORT.query('/PASSPORT/ADDRESS') ADDRESS
from PASSPORTS inner join STUDENT on PASSPORTS.STUDENT = STUDENT.IDSTUDENT
rollback tran

select 


-- ������������� �������
go
alter trigger TR_UNIVERSITY on database for CREATE_TABLE, DROP_TABLE, ALTER_TABLE as
return
go

-- 5 �����
use UniversityLab4
go
create xml schema collection Student as 
'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="PASSPORT"maxOccurs="1" minOccurs="1">  
       <xs:complexType><xs:sequence>
	   <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
   <xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
       <xs:complexType>
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>'