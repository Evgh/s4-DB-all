Use E_Univer;
go

--------------------------------------------------------------------------------------------- 1

select rtrim(TEACHER)[CODE], rtrim(PULPIT)[PULPIT], TEACHER_NAME[подробно/TEACHER],rtrim(GENDER)[подробно/GENDER] from TEACHER
where PULPIT = 'ИСиТ' 
for xml path, root('Teachers_ISIT');

select rtrim(TEACHER)[CODE], TEACHER_NAME[TEACHER],rtrim(GENDER)[GENDER],rtrim(PULPIT)[PULPIT] from TEACHER
where PULPIT = 'ИСиТ' 
for xml RAW, root('Teachers_ISIT');

--------------------------------------------------------------------------------------------- 2
select 
	rtrim([aud].AUDITORIUM) [aud], 
	[aud].AUDITORIUM_CAPACITY [capacity],

	[t].AUDITORIUM_TYPENAME [typename]

from AUDITORIUM[aud] inner join AUDITORIUM_TYPE[t]  
on [aud].AUDITORIUM_TYPE = [t].AUDITORIUM_TYPE 
where [aud].AUDITORIUM_TYPE = 'ЛК'
for xml auto, root('auditoriums')


select 
	rtrim([aud].AUDITORIUM) [aud], 
	rtrim([aud].AUDITORIUM_CAPACITY) [capacity],

	rtrim([t].AUDITORIUM_TYPE) [t/type],
	rtrim([t].AUDITORIUM_TYPENAME) [t/typename]

from AUDITORIUM[aud] inner join AUDITORIUM_TYPE[t]  
on [aud].AUDITORIUM_TYPE = [t].AUDITORIUM_TYPE 
where [aud].AUDITORIUM_TYPE = 'ЛК'
for xml path, elements, root('auditoriums')

--------------------------------------------------------------------------------------------- 3
begin tran 

DECLARE @DocHandle int
DECLARE @XmlDocument nvarchar(1000)

SET @XmlDocument = N'<list>
<item><subj>КУРЛ</subj><name>Курлык</name><pulpit>ИСиТ</pulpit></item>
<item><subj>ЧИР</subj><name>Чирик</name><pulpit>ИСиТ</pulpit></item>
<item><subj>КРЯ</subj><name>Кря</name><pulpit>ИСиТ</pulpit></item>
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
			'Касперович Евгения Николаевна', 
			'1999-01-06',
			'<Студент>
			<Паспорт серия="МР" номер="3604980" дата="02.02.2015"/>
			<Телефон>1234567</Телефон>
			<Адрес>
				   <Страна>Беларусь</Страна>
				   <Город>Минск</Город>
				   <Улица>Захарова</Улица>
				   <Дом>61</Дом>
				   <Квартира>13</Квартира>
			</Адрес>
			</Студент>')

update STUDENT set INFO = 
'<Студент>
	<Паспорт серия="МР" номер="3604980" дата="02.02.2015"/>
	<Телефон>7654321</Телефон>
	<Адрес>
		   <Страна>Беларусь</Страна>
		   <Город>Минск</Город>
		   <Улица>Захарова</Улица>
		   <Дом>61</Дом>
		   <Квартира>13</Квартира>
	</Адрес>
</Студент>' where INFO.value('(Студент/Адрес/Город)[1]','varchar(10)') ='Минск';

select IDGROUP, NAME, BDAY, INFO.value('(/Студент/Адрес/Страна)[1]','varchar(10)') [страна], INFO.query('/Студент/Адрес')[адрес]
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
       <xs:element name="студент">  
       <xs:complexType><xs:sequence>
       <xs:element name="паспорт" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="серия" type="xs:string" use="required" />
       <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="дата"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="телефон" type="xs:unsignedInt"/>
   <xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>'
alter table STUDENT alter column INFO xml(Student)

begin tran

insert into STUDENT (IDGROUP,NAME,BDAY,INFO)
values (	1,
			'Касперович Евгения Николаевна', 
			'1999-01-06',

			'<студент>
			<паспорт серия="МР" номер="3604980" дата="02.02.2015"> </паспорт>

			<телефон>1234567</телефон>
			<адрес>
				   <страна>Беларусь</страна>
				   <город>Минск</город>
				   <улица>Захарова</улица>
				   <дом>61</дом>
				   <квартира>13</квартира>
			</адрес>
			</студент>')

update STUDENT set INFO = 
'<студент>
	<паспорт серия="МР" номер="3604980" дата="02.02.2015"/>
	<телефон>7654321</телефон>
	<адрес>
		   <страна>Беларусь</страна>
		   <город>Минск</город>
		   <улица>Захарова</улица>
		   <дом>61</дом>
		   <квартира>13</квартира>
	</адрес>
</студент>' where INFO.value('(студент/адрес/город)[1]','varchar(10)') ='Минск';

select IDGROUP,NAME,BDAY, 
INFO.value('(/студент/адрес/страна)[1]','varchar(10)') [страна],
INFO.query('/студент/адрес')[адрес]
from  STUDENT;

rollback tran

--------------------------------------------------------------------------------------------- 7

 select 
	rtrim(FACULTY.FACULTY) as '@код',
	(select COUNT(*) from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY) as 'количество_кафедр',

	(select 
		rtrim(PULPIT.PULPIT) as '@код',
		(select 
			rtrim(TEACHER.TEACHER) as 'преподаватель/@код', 
			TEACHER.TEACHER_NAME as 'преподаватель'
		from TEACHER where TEACHER.PULPIT = PULPIT.PULPIT for xml path(''),type, root('преподаватели'))
	from PULPIT where PULPIT.FACULTY = FACULTY.FACULTY for xml path('кафедра'), type, root('кафедры'))

from FACULTY for xml path('факультет'), type, root('университет')


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
