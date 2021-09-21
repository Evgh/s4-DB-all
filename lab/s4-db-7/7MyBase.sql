USE KASPER_MyNewBase;
SELECT 
		min(CREDITS.credit_mark) [����������� ������],  
		max(CREDITS.credit_mark) [������������ ������],  
		avg(CREDITS.credit_mark) [������� ������],
		sum(CREDITS.credit_mark) [����� ����],
		count(CREDITS.credit_mark) [���������� ���������� �������]
	FROM CREDITS;

-- 
USE KASPER_MyNewBase;
SELECT 
		STUDENTS.student_name, 
		min(CREDITS.credit_mark) [����������� ������],  
		max(CREDITS.credit_mark) [������������ ������],  
		avg(CREDITS.credit_mark) [������� ������],
		sum(CREDITS.credit_mark) [����� ����],
		count(CREDITS.credit_mark) [���������� ���������� �������]
	FROM CREDITS join STUDENTS on STUDENTS.student_id = CREDITS.student_id
	GROUP BY STUDENTS.student_name;

-- 
USE KASPER_MyNewBase;
SELECT *
		FROM 
		(
		SELECT 
			case 
			when CREDITS.credit_mark = 10 then '10'
			when CREDITS.credit_mark between 8 and 9 then '9-8'
			when CREDITS.credit_mark between 6 and 7 then '7-6'
			when CREDITS.credit_mark between 4 and 5 then '5-4'
			end [������], 
			COUNT(*)[����������]
		FROM CREDITS 
		GROUP BY 
			case 
			when CREDITS.credit_mark = 10 then '10'
			when CREDITS.credit_mark between 8 and 9 then '9-8'
			when CREDITS.credit_mark between 6 and 7 then '7-6'
			when CREDITS.credit_mark between 4 and 5 then '5-4'
			end
		) as T
		ORDER BY ������ desc;

-- 
USE KASPER_MyNewBase;
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS
EXCEPT
(
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS WHERE STUDENTS.student_name like '�%'
UNION 
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS WHERE STUDENTS.student_surname like '�%'
)