USE KASPER_MyNewBase;

-- � ���� ���� ������ ���� 7
SELECT STUDENTS.student_name FROM STUDENTS 
		WHERE STUDENTS.student_id in (SELECT CREDITS.student_id FROM CREDITS WHERE credit_mark>=7);


-- ������� � ����� ������� ������� �� ������� �������� 
SELECT DISCIPLINES.discipline_name, STUDENTS.student_name 
		FROM CREDITS join STUDENTS on CREDITS.student_id = STUDENTS.student_id
				join DISCIPLINES on DISCIPLINES.discipline_code = CREDITS.discipline_code
		WHERE STUDENTS.student_id in (SELECT top(1) student_id FROM CREDITS WHERE CREDITS.discipline_code = DISCIPLINES.discipline_code ORDER BY credit_mark desc);

-- C�������, � ������� ��� �� ������ ������ 
SELECT STUDENTS.student_name
		FROM STUDENTS
		WHERE not exists (SELECT * FROM CREDITS WHERE CREDITS.student_id = STUDENTS.student_id);
 