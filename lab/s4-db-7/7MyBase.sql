USE KASPER_MyNewBase;
SELECT 
		min(CREDITS.credit_mark) [Минимальная оценка],  
		max(CREDITS.credit_mark) [Максимальная оценка],  
		avg(CREDITS.credit_mark) [Средняя оценка],
		sum(CREDITS.credit_mark) [Сумма всех],
		count(CREDITS.credit_mark) [Количество полученных зачетов]
	FROM CREDITS;

-- 
USE KASPER_MyNewBase;
SELECT 
		STUDENTS.student_name, 
		min(CREDITS.credit_mark) [Минимальная оценка],  
		max(CREDITS.credit_mark) [Максимальная оценка],  
		avg(CREDITS.credit_mark) [Средняя оценка],
		sum(CREDITS.credit_mark) [Сумма всех],
		count(CREDITS.credit_mark) [Количество полученных зачетов]
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
			end [Оценки], 
			COUNT(*)[Количество]
		FROM CREDITS 
		GROUP BY 
			case 
			when CREDITS.credit_mark = 10 then '10'
			when CREDITS.credit_mark between 8 and 9 then '9-8'
			when CREDITS.credit_mark between 6 and 7 then '7-6'
			when CREDITS.credit_mark between 4 and 5 then '5-4'
			end
		) as T
		ORDER BY Оценки desc;

-- 
USE KASPER_MyNewBase;
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS
EXCEPT
(
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS WHERE STUDENTS.student_name like 'А%'
UNION 
SELECT STUDENTS.student_name, STUDENTS.student_surname FROM STUDENTS WHERE STUDENTS.student_surname like 'К%'
)