Use E_Univer;
go

--------------------------------------------------------------------------------------------- 1

select rtrim(TEACHER)[CODE], rtrim(PULPIT)[PULPIT], TEACHER_NAME[��������/TEACHER],rtrim(GENDER)[��������/GENDER] from TEACHER
where PULPIT = '����' 
for xml path, root('Teachers_ISIT');

select rtrim(TEACHER)[CODE], TEACHER_NAME[TEACHER],rtrim(GENDER)[GENDER],rtrim(PULPIT)[PULPIT] from TEACHER
where PULPIT = '����' 
for xml RAW, root('Teachers_ISIT');

--------------------------------------------------------------------------------------------- 2
select 
	rtrim([aud].AUDITORIUM) [aud], 
	[aud].AUDITORIUM_CAPACITY [capacity],

	[t].AUDITORIUM_TYPENAME [typename]

from AUDITORIUM[aud] inner join AUDITORIUM_TYPE[t]  
on [aud].AUDITORIUM_TYPE = [t].AUDITORIUM_TYPE 
where [aud].AUDITORIUM_TYPE = '��'
for xml auto, root('auditoriums')


select 
	rtrim([aud].AUDITORIUM) [aud], 
	rtrim([aud].AUDITORIUM_CAPACITY) [capacity],

	rtrim([t].AUDITORIUM_TYPE) [t/type],
	rtrim([t].AUDITORIUM_TYPENAME) [t/typename]

from AUDITORIUM[aud] inner join AUDITORIUM_TYPE[t]  
on [aud].AUDITORIUM_TYPE = [t].AUDITORIUM_TYPE 
where [aud].AUDITORIUM_TYPE = '��'
for xml path, elements, root('auditoriums')

--------------------------------------------------------------------------------------------- 3
begin tran 

DECLARE @DocHandle int
DECLARE @XmlDocument nvarchar(1000)

SET @XmlDocument = N'<list>
<item><subj>����</subj><name>������</name><pulpit>����</pulpit></item>
<item><subj>���</subj><name>�����</name><pulpit>����</pulpit></item>
<item><subj>���</subj><name>���</name><pulpit>����</pulpit></item>
</list>'

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument

insert SUBJECT select [subj], [name], [pulpit] 
from openxml(@DocHandle, '/list/item',2)     
with(subj char(10), name varchar(100), [pulpit] char(20))


SELECT * FROM OPENXML (@DocHandle, '/list/item',2)
WITH (subj char(10), name varchar(100), [pulpit] char(20))

rollback tran


--------------------------------------------------------------------------------------------- 4
use E_Univer;
begin tran
insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'���������� ������� ����������', 
			'1999-01-06',
			'<�������>
			<������� �����="��" �����="3604980" ����="02.02.2015"/>
			<�������>1234567</�������>
			<�����>
				   <������>��������</������>
				   <�����>�����</�����>
				   <�����>��������</�����>
				   <���>61</���>
				   <��������>13</��������>
			</�����>
			</�������>')

update STUDENT set INFO = 
'<�������>
	<������� �����="��" �����="3604980" ����="02.02.2015"/>
	<�������>7654321</�������>
	<�����>
		   <������>��������</������>
		   <�����>�����</�����>
		   <�����>��������</�����>
		   <���>61</���>
		   <��������>13</��������>
	</�����>
</�������>' where INFO.value('(�������/�����/�����)[1]','varchar(10)') ='�����';

select IDGROUP, NAME, BDAY, INFO.value('(/�������/�����/������)[1]','varchar(10)') [������], INFO.query('/�������/�����')[�����]
from  STUDENT;

rollback

--------------------------------------------------------------------------------------------- 5
use E_Univer;


drop xml schema collection Student 
create xml schema collection Student 
as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="�������">  
       <xs:complexType><xs:sequence>
       <xs:element name="�������" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="�����" type="xs:string" use="required" />
       <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="����"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
   <xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>'
alter table STUDENT alter column INFO xml(Student)

begin tran

insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'���������� ������� ����������', 
			'1999-01-06',

			'<�������>
			<������� �����="��" �����="3604980" ����="02.02.2015"> </�������>

			<�������>1234567</�������>
			<�����>
				   <������>��������</������>
				   <�����>�����</�����>
				   <�����>��������</�����>
				   <���>61</���>
				   <��������>13</��������>
			</�����>
			</�������>')

update STUDENT set INFO = 
'<�������>
	<������� �����="��" �����="3604980" ����="02.02.2015"/>
	<�������>7654321</�������>
	<�����>
		   <������>��������</������>
		   <�����>�����</�����>
		   <�����>��������</�����>
		   <���>61</���>
		   <��������>13</��������>
	</�����>
</�������>' where INFO.value('(�������/�����/�����)[1]','varchar(10)') ='�����';

select IDGROUP,NAME,BDAY, 
INFO.value('(/�������/�����/������)[1]','varchar(10)') [������],
INFO.query('/�������/�����')[�����]
from  STUDENT;

rollback tran

--------------------------------------------------------------------------------------------- 7

 select 
	rtrim(FACULTY.FACULTY) as '@���',
	(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as '����������_������',

	(select 
		rtrim(PULPIT.PULPIT) as '@���',
		(select 
			rtrim(TEACHER.TEACHER) as '�������������/@���', 
			TEACHER.TEACHER_NAME as '�������������'
		from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('�������������'))
	from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('�������'), type, root('�������'))

from FACULTY for xml path('���������'), type, root('�����������')


--------------------------------------------------------------------------------------------- 6
use KASPER_MyNewBase
select 
	[d].discipline_code [code], 
	discipline_name [name], 
	discipline_lk [lessons/lk],  
	discipline_lb [lessons/lb],  
	discipline_pz [lessons/pz]  
from DISCIPLINES [d] join CREDITS [cr] on [cr].discipline_code = [d].discipline_code
for xml PATH('Discipline'), root('Disciplines')
