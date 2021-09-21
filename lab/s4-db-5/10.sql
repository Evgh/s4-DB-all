USE KASPER_MyNewBase;

-- ������� ���������, ��� ������ ������� ���� 7 
SELECT distinct STUDENTS.student_name, STUDENTS.student_surname FROM 
	STUDENTS JOIN CREDITS ON STUDENTS.student_id = CREDITS.student_id
	WHERE CREDITS.credit_mark >= 7

-- ������� ������������ ���������
SELECT STUDENTS.student_name, DISCIPLINES.discipline_code, CREDITS.credit_mark
	FROM STUDENTS CROSS JOIN DISCIPLINES 
		LEFT OUTER JOIN CREDITS ON STUDENTS.student_id = CREDITS.student_id AND DISCIPLINES.discipline_code = CREDITS.discipline_code
	ORDER BY student_name, discipline_code

-- ������� ���������, ������� �������� �� ��� ������ 
SELECT distinct STUDENTS.student_name
	FROM STUDENTS CROSS JOIN DISCIPLINES 
		LEFT OUTER JOIN CREDITS ON STUDENTS.student_id = CREDITS.student_id AND DISCIPLINES.discipline_code = CREDITS.discipline_code
	WHERE credit_id is null
	ORDER BY STUDENTS.student_name;
		

-- 