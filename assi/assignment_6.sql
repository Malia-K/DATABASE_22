--2
CREATE TABLE locations(
    location_id serial PRIMARY KEY ,
    street_address varchar(25),
    postal_code varchar(30),
    city varchar(30),
    state_province varchar(12)
);

CREATE TABLE departments(
    department_id serial PRIMARY KEY,
    department_name varchar(50) unique,
    budget integer,
    location_id integer references locations
);

CREATE TABLE employees(
    employee_id serial PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50),
    phone_number varchar(20),
    salary integer,
    department_id integer references departments
);


--3
INSERT INTO locations
VALUES(1, 'Ainabulak-3', '155', 'Almaty', 'Almaty obl');

INSERT INTO locations
VALUES(2, 'Atyrau mcrayon', '24', 'Atyrau', 'Atyrau obl');

INSERT INTO locations
VALUES(3, 'Tole bi', '59', 'Almaty', 'Almaty obl');

INSERT INTO locations
VALUES(4, 'Kulager', '148', 'Almaty', 'Almaty obl');

INSERT INTO locations
VALUES(5, 'bir address', '17', 'Moscow', 'Moscow obl');

SELECT * FROM locations;

INSERT INTO departments
VALUES(30, 'Technodom', 1560000, 4);

INSERT INTO departments
VALUES(50, 'KBTU', 5900000, 3);

INSERT INTO departments
VALUES(60, 'Amanat', 999999999, 1);

INSERT INTO departments
VALUES(70, 'Starbucks', 5800000, 2);

INSERT INTO departments
VALUES(80, 'Magnum', 7000000, 5);

SELECT * FROM departments;

DROP TABLE employees;

INSERT INTO employees
VALUES(default, 'Nurdaulet', 'Toleugaliev', 'n_toleugaliev@kbtu.kz', '+77761002003', 150000, 80);

INSERT INTO employees
VALUES(default, 'Alima', 'Kusmanova', 'ali_kusmanova@kbtu.kz', '+77770870094', 350000, 50);

INSERT INTO employees
VALUES(default, 'Riza', 'Nurmagambetkyzy', 'r_nurmagambetkyzy@kbtu.kz', '+77767328171', 750000, 60);

INSERT INTO employees
VALUES(default, 'Erdaut', 'Torekhan', 'e_torekhan@kbtu.kz', '+77770290787', 320000, 70);

INSERT INTO employees
VALUES(default, 'Alikhan', 'Gubayev', 'a_gubayev@kbtu.kz', '+77471597863', 260000, 30);

INSERT INTO employees
VALUES(default, 'Ayan', 'Igali', 'a_igali@kbtu.kz', '+77766549865');
SELECT * FROM employees;


--4
SELECT first_name, last_name, employees.department_id, department_name
FROM employees
INNER JOIN departments
ON employees.department_id = departments.department_id;

--5
SELECT first_name, last_name, employees.department_id, department_name
FROM employees
INNER JOIN departments
ON employees.department_id = departments.department_id
AND (employees.department_id = 80 OR employees.department_id = 30);

--6
SELECT first_name, last_name, department_name, city, state_province
FROM employees
INNER JOIN departments ON departments.department_id = employees.department_id
INNER JOIN locations   ON locations.location_id = departments.location_id;

--7
SELECT * FROM departments
LEFT JOIN employees ON departments.department_id = employees.department_id
WHERE employees.department_id IS NULL OR employees.department_id IS NOT NULL;

--8
SELECT first_name, last_name, employees.department_id, department_name
FROM employees
FULL JOIN departments  on departments.department_id = employees.department_id
WHERE employees.department_id IS NULL OR employees.department_id IS NOT NULL;


--9
SELECT last_name, first_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.department_id
INNER JOIN locations   ON departments.location_id = locations.location_id
WHERE locations.city = 'Moscow';


