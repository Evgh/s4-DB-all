 -- 6
USE E_Univer;

INSERT into PROGRESS(IDSTUDENT, SUBJECT, NOTE) values (1040, '����', 3);
INSERT into PROGRESS(IDSTUDENT, SUBJECT, NOTE) values (1040, '��', 3);

SELECT STUDENT.IDSTUDENT, PROGRESS.NOTE
FROM PROGRESS
	join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
ORDER BY IDSTUDENT;


DECLARE task_6 CURSOR LOCAL DYNAMIC 
					for 
					SELECT STUDENT.IDSTUDENT, PROGRESS.NOTE
					FROM PROGRESS
						join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
						join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
					FOR UPDATE;

DECLARE @idstudent int, @note int, @badStudent int;
DECLARE @increaseMark int = 1000;


OPEN task_6

	FETCH FIRST from task_6 into @idstudent, @note;

	WHILE @@FETCH_STATUS = 0
		begin

			IF @note < 4			-- ���� �� ������� ������, ��� ������ ������ 4  
				begin
			
					SET @badStudent = @idstudent;			-- ���������� ���� ���������
					FETCH FIRST from task_6 into @idstudent, @note;			-- ������������ � ������ � ���� �� ������� �� �����
					WHILE @@FETCH_STATUS = 0
						begin 
							IF @idstudent = @badStudent 			-- ������� ������ ������, ��������� � ���������� 
								begin 
									DELETE PROGRESS where CURRENT OF task_6;									
								end
							FETCH NEXT from task_6 into @idstudent, @note;
						end

					FETCH FIRST from task_6 into @idstudent, @note; -- ����� ������������ � ������
				end

			ELSE
			if @idstudent = @increaseMark
				begin
					UPDATE PROGRESS SET note = note + 1 WHERE IDSTUDENT = @idstudent AND note < 10; 
				end

				FETCH NEXT from task_6 into @idstudent, @note; -- ���� ��� ��, �� ������������ � ��������� ������

		end
CLOSE task_6;

SELECT STUDENT.IDSTUDENT, PROGRESS.NOTE
FROM PROGRESS
	join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
	join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP
ORDER BY IDSTUDENT;




