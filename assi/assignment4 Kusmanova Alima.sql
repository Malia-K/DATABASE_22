-- TASK 1
--a)
SELECT title FROM course
WHERE dept_name = 'Biology' AND credits > 3;

--b)
SELECT * FROM classroom
WHERE building = 'Watson' OR building = 'Painter';

--c)
SELECT * FROM course
WHERE dept_name = 'Comp. Sci.';

--d)
SELECT * FROM course
WHERE course_id in(
        SELECT course_id
        FROM section
        WHERE semester = 'Spring'
);

-- e)
SELECT * FROM student
WHERE tot_cred between 45 and 85;

--f)
SELECT * FROM course
WHERE title like '%a' or title like '%e' or title like '%y'
or title like 'u' or title like 'i' or title like 'o'
or title like 'E' or title like 'Y' or title like 'I'
or title like 'O' or title like 'A' or title like 'U';


--g)
SELECT * FROM course
WHERE course_id IN (
    SELECT course_id FROM prereq
    WHERE prereq_id = 'EE-181'
);


--TASK2
--a)
SELECT dept_name, AVG(salary)  FROM instructor
GROUP BY dept_name
ORDER BY AVG(salary);

--b)
SELECT building, COUNT(*) FROM section
GROUP BY building
ORDER BY COUNT(*) DESC
LIMIT 1;

--c)
SELECT dept_name, COUNT(*) from course
GROUP BY dept_name
ORDER BY COUNT(*)
LIMIT 1;

--d)
SELECT student.id, name, COUNT(course_id) FROM student, takes
WHERE student.id = takes.id and course_id LIKE 'CS-%'
GROUP BY student.id, name
HAVING COUNT(course_id) > 3;

--e)
SELECT id, name FROM instructor, department
WHERE  instructor.dept_name = department.dept_name and building = 'Taylor';

--f)
SELECT * from instructor
WHERE dept_name = 'Biology' OR dept_name = 'Philosophy' OR dept_name = 'Music';

--g)
SELECT * FROM instructor
WHERE id IN(
    SELECT id from teaches
    WHERE year = 2018 AND id NOT IN(
        SELECT id from teaches
        WHERE year = 2017)
    );

--TASK3
--a)
SELECT student.id, name, dept_name, tot_cred, grade FROM student, takes
WHERE student.id = takes.id AND dept_name = 'Comp. Sci.' AND (grade = 'A' OR grade = 'A-')
ORDER BY grade;

--b)

SELECT i_id, s_id FROM  advisor,takes
WHERE s_id = id AND grade in ('B','B+', 'A-','A')
GROUP BY i_id, s_id;

--c)
SELECT DISTINCT dept_name FROM course
WHERE course_id IN (
    SELECT course_id FROM takes
    WHERE grade NOT IN ('F', 'C-','C','C+'));

--d)

SELECT * FROM instructor
WHERE id IN (
    SELECT DISTINCT id FROM teaches
    WHERE course_id IN (
        SELECT course_id FROM takes
        WHERE grade NOT IN ('A', 'A-')));

--e)
SELECT course_id FROM section
WHERE time_slot_id IN (
    SELECT DISTINCT time_slot_id FROM time_slot
    WHERE end_hr < 13);