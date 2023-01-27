--1)
--a)
CREATE OR REPLACE FUNCTION increment(INOUT a numeric)
AS $$
    BEGIN
        a := a + 1;
    END;
$$ LANGUAGE plpgsql;

SELECT increment(1.5 );


--b)
CREATE OR REPLACE FUNCTION cube(INOUT a numeric)
AS $$
    BEGIN
        a := a * a * a;
    END;
$$ LANGUAGE plpgsql;

SELECT cube(2.5);



--c)
CREATE OR REPLACE FUNCTION sum_of_two_numbers(
        a numeric,
        b numeric,
        OUT sum_of_them numeric)
AS $$
    BEGIN
        sum_of_them := a + b;
    END;
$$ LANGUAGE plpgsql;


SELECT sum_of_two_numbers(4.5,5);



--d)
CREATE OR REPLACE FUNCTION div_by_2(
        a numeric,
        OUT isValid bool)
AS $$
    BEGIN
        CASE WHEN a % 2 = 0 THEN isValid := true;
        ELSE isValid := false;
        END CASE;
    END;
$$ LANGUAGE plpgsql;

SELECT div_by_2(16);


--e)
CREATE OR REPLACE FUNCTION average(
        VARIADIC arr NUMERIC[],
        OUT ans NUMERIC)
AS $$
    BEGIN
        SELECT INTO ans AVG(arr[i]) FROM generate_subscripts(arr, 1) g(i);
    END;
$$ LANGUAGE  plpgsql;

SELECT average(1,2,3);

--f)

CREATE OR REPLACE FUNCTION cnt(VARIADIC arr NUMERIC[])
    RETURNS TABLE(
        item NUMERIC,
        counter BIGINT
    )
AS $$
    BEGIN
        RETURN QUERY
            SELECT arr[i], COUNT(arr[i])
            FROM generate_subscripts(arr,1) g(i)
            GROUP BY arr[i]
            ORDER BY arr[i];
    END;
$$ LANGUAGE plpgsql;

drop function cnt(arr NUMERIC[]);


SELECT * FROM cnt(1,1,2,4,6,5,5,3);

--g)

CREATE TABLE user_table(
    login varchar(50),
    password varchar(50)
);

INSERT INTO user_table
VALUES('Alima', '1234');

CREATE OR REPLACE FUNCTION verify_password(
        log varchar,
        passw varchar
)
RETURNS bool
AS $$
    BEGIN
        return (SELECT password
                FROM user_table
                WHERE login = log) = passw;
    END;
$$LANGUAGE plpgsql;


SELECT verify_password('Alima', '123');
SELECT verify_password('Alima', '1234');


--h)
CREATE OR REPLACE FUNCTION func_h(
        IN str varchar,
        OUT small varchar,
        OUT large varchar
)
AS $$
    BEGIN
        small := lower(str);
        large := upper(str);
    END;
$$LANGUAGE plpgsql;

SELECT func_h('heLLo');





--2)
--a)

create table occured_actions
(
    time timestamp,
    action varchar(255)
);
create or replace function action()
    returns trigger as $$
    BEGIN
        insert into occured_actions(time, action) VALUES (now(), 'something happened');
        return NEW;
    end;
$$
language plpgsql;

CREATE TABLE occured_action(
    happened_time TIMESTAMP,
    action VARCHAR(255)
);

CREATE OR REPLACE FUNCTION made_action()
RETURNS TRIGGER
AS $$
    BEGIN
        INSERT INTO occured_action
        VALUES(now(),  'user made an action!');
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- DROP FUNCTION made_action();
--

CREATE TRIGGER  action_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON user_table
    FOR EACH ROW EXECUTE PROCEDURE made_action();

INSERT INTO user_table
VALUES ('Some Name', '45689');


SELECT * FROM occured_action;


--b)

CREATE TABLE person_info(
    date_birth date,
    ages int
);

CREATE OR REPLACE FUNCTION age_computer()
RETURNS TRIGGER
AS $$
    BEGIN
        NEW.ages = date_part('year',age(current_date, NEW.date_birth));
        return NEW;
    END;
$$LANGUAGE plpgsql;


CREATE TRIGGER date_insert
    BEFORE INSERT ON person_info
    FOR EACH ROW EXECUTE FUNCTION age_computer();

INSERT INTO person_info(date_birth)
VALUES ('1994-04-02');

SELECT * FROM person_info;



--c)

CREATE TABLE prices(
    init_price float,
    price_tax float
);

CREATE OR REPLACE FUNCTION tax_computer()
RETURNS TRIGGER
AS $$
    BEGIN
        NEW.price_tax = NEW.init_price * 1.12;
        return NEW;
    END;
$$LANGUAGE plpgsql;


CREATE TRIGGER tax_compute
    BEFORE INSERT ON prices
    FOR EACH ROW EXECUTE  FUNCTION  tax_computer();

INSERT INTO prices(init_price)
VALUES (7845);

SELECT * FROM prices;

--d)

CREATE OR REPLACE FUNCTION cancel_del()
RETURNS TRIGGER
AS $$
    BEGIN
        RAISE EXCEPTION 'OOPS, you can not delete it';
        return NEW;
    END;
$$LANGUAGE plpgsql;

CREATE TRIGGER no_deletion
    BEFORE DELETE ON prices
    FOR EACH ROW EXECUTE FUNCTION cancel_del();

DELETE FROM prices
WHERE init_price > 1000;



--e)

CREATE TABLE table_e(
    arr NUMERIC[],
    is_div_by_2 BOOL,
    average NUMERIC
);

CREATE OR REPLACE FUNCTION execute_functions()
RETURNS TRIGGER
AS $$
    BEGIN
        PERFORM div_by_2(8);
--         PERFORM average(table_e.arr);
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER call_func_d_e
    BEFORE UPDATE OR INSERT ON table_e
    FOR EACH ROW EXECUTE FUNCTION execute_functions();


--3)

CREATE TABLE employee(
    id INTEGER PRIMARY KEY,
    name VARCHAR(40),
    date_of_birth DATE,
    age INTEGER,
    salary INTEGER,
    workexperience INTEGER,
    discount INTEGER
);

--a)
CREATE OR REPLACE PROCEDURE upd_salary(person_id INTEGER)
AS $$
    DECLARE
        num INTEGER;
        num2 INTEGER;
    BEGIN
        num := (SELECT  workexperience FROM employee WHERE person_id = employee.id) / 2;
        num2 := (SELECT workexperience FROM  employee WHERE person_id = employee.id) / 5;
        IF (num > 0) THEN
            WHILE(num > 0) LOOP
                UPDATE employee
                SET salary = salary * (1.2) , discount = 10
                WHERE person_id = employee.id;
                num = num - 1;
            END LOOP;
        END IF;

        IF (num2 > 0) THEN
            WHILE(num2 > 0) LOOP
                UPDATE employee
                SET discount = discount + 1.01 * discount
                WHERE person_id = employee.id;
                num2 = num2 - 1;
            END LOOP;
        END if;
    END;
$$LANGUAGE plpgsql;

INSERT INTO employee(id, workexperience, salary)
VALUES (5165, 5, 150000);

CALL upd_salary(5165);
--2
CREATE OR REPLACE PROCEDURE new_salary2(person_id int)
AS $$
    DECLARE
        ages INTEGER;
        exp INTEGER;
    BEGIN
        exp := (SELECT workexperience FROM employee WHERE person_id = employee.id);
        ages := (SELECT age FROM employee WHERE person_id = employee.id);
        IF(ages >= 40) THEN
            UPDATE employee
            SET salary = salary * 1.15
            WHERE person_id = employee.id;
            IF(exp >= 8) THEN
                UPDATE employee
                SET salary = salary * 1.15, discount = 20
                WHERE person_id = employee.id;
            END IF;
        END if;
    END;
$$LANGUAGE plpgsql;

INSERT INTO employee(id, age, workexperience, salary)
VALUES (6464, 42, 25, 210000);

CALL new_salary2(6464);

SELECT * FROM employee;

