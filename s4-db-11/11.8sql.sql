-- 8*
USE E_Univer;

DECLARE teachers CURSOR LOCAL STATIC
for
SELECT
	F.FACULTY,
	P.PULPIT,	
	(select count(*) from TEACHER join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY 
					 where FACULTY.FACULTY = F.FACULTY and PULPIT.PULPIT = P.PULPIT) [Кол-во]
	FROM FACULTY as F left join PULPIT as P on P.FACULTY = F.FACULTY


DECLARE subjects CURSOR LOCAL STATIC 
for
SELECT 
	FACULTY.FACULTY,
	PULPIT.PULPIT,
	SUBJECT.SUBJECT
	
	FROM FACULTY 
		join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY
		join SUBJECT on SUBJECT.PULPIT = PULPIT.PULPIT 

DECLARE pulpits CURSOR LOCAL STATIC 
for
SELECT 
	FACULTY.FACULTY, PULPIT.PULPIT FROM FACULTY left join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY;

DECLARE faculties CURSOR LOCAL STATIC 
for
SELECT 
	FACULTY.FACULTY FROM FACULTY 


DECLARE @space varchar(15) = '';
DECLARE @ffaculty varchar(5), @pfaculty varchar(5), @sfaculty varchar(5), @tfaculty varchar(5);
DECLARE @ppulpit varchar(10), @spulpit varchar(10), @tpulpit varchar(10);
DECLARE @subject varchar(10);
DECLARE @teachers_amount int; 
DECLARE @subject_list varchar(100) = '';

OPEN faculties 	
	FETCH faculties into @ffaculty;

	WHILE @@FETCH_STATUS = 0 
	begin
		PRINT @space + 'Факультет: ' + @ffaculty;

		OPEN pulpits; 
			SET @space = '	';
			FETCH pulpits into @pfaculty, @ppulpit;

			WHILE @@FETCH_STATUS = 0 
			begin 
				IF @pfaculty = @ffaculty 
					PRINT @space + 'Кафедра ' + @ppulpit; 

				OPEN teachers;
					SET @space = '		';
					FETCH teachers into @tfaculty, @tpulpit, @teachers_amount;	
					WHILE @@FETCH_STATUS = 0 
					begin 
						IF @tfaculty = @ffaculty and @tpulpit = @ppulpit
						begin 
							PRINT @space + 'Количество преподавателей: ' + cast(@teachers_amount as varchar(2));

							SET @subject_list = '';

							OPEN subjects  -- открываю список предметов тут, чтобы сформировать и вывести дисциплины только один раз
								FETCH subjects into @sfaculty, @spulpit, @subject

								WHILE @@FETCH_STATUS = 0
								begin
									IF @sfaculty = @ffaculty and @spulpit = @ppulpit
										SET @subject_list = @subject_list + @subject + ', ';

									FETCH subjects into @sfaculty, @spulpit, @subject
								end 
							CLOSE subjects;


							IF @subject_list = '' 
								SET @subject_list = 'нет';
							PRINT @space + 'Дисциплины: ' + @subject_list;
						end

						FETCH teachers into @tfaculty, @tpulpit, @teachers_amount;
					end 
				CLOSE teachers;
				
				SET @space = '	';
				FETCH pulpits into @pfaculty, @ppulpit;
			end
		CLOSE pulpits; 		
	
		SET @space = '';
		FETCH faculties into @ffaculty;		
	end 
CLOSE faculties