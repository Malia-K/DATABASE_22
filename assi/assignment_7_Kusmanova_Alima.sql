create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    commission float
);

INSERT INTO dealer (id, name, location, commission) VALUES (101, 'Oleg', 'Astana', 0.15);
INSERT INTO dealer (id, name, location, commission) VALUES (102, 'Amirzhan', 'Almaty', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (105, 'Ademi', 'Taldykorgan', 0.11);
INSERT INTO dealer (id, name, location, commission) VALUES (106, 'Azamat', 'Kyzylorda', 0.14);
INSERT INTO dealer (id, name, location, commission) VALUES (107, 'Rahat', 'Satpayev', 0.13);
INSERT INTO dealer (id, name, location, commission) VALUES (103, 'Damir', 'Aktobe', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Bekzat', 'Satpayev', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Aruzhan', 'Almaty', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Almaty', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Yerkhan', 'Taraz', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Aibek', 'Kyzylorda', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Arsen', 'Taldykorgan', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Alen', 'Shymkent', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Zhandos', 'Astana', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2021-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2021-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2021-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2021-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2021-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2021-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2021-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2021-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2021-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2021-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2021-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2021-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

CREATE OR REPLACE VIEW view_b
AS
    SELECT sell.date
    FROM sell
    GROUP BY sell.date
    ORDER BY SUM(amount) DESC
    LIMIT 5;

SELECT * FROM view_b;
-- 1)
--a)
SELECT *
FROM client
WHERE priority < 300;


--b)
SELECT *
FROM dealer
CROSS JOIN client;


--c)
SELECT dealer.id, dealer.name, dealer.location, dealer.commission, client.name, client.city, client.priority, sell.id, sell.date, sell.amount
FROM dealer
INNER JOIN client  on dealer.id = client.dealer_id
INNER JOIN sell on dealer.id = sell.dealer_id;

--d)
SELECT *
FROM dealer
INNER JOIN
    client on dealer.id = client.dealer_id
WHERE client.city = dealer.location;

--e)
SELECT sell.id, sell.amount, client.name, client.city
FROM client
INNER JOIN
    sell ON sell.client_id = client.id
WHERE sell.amount BETWEEN 200 AND 500;

--f)
SELECT DISTINCT dealer.id, dealer.name, dealer.location, c.num_of_clients
FROM dealer
INNER JOIN (
    SELECT  count(client.dealer_id) as num_of_clients, client.dealer_id
    FROM client
    GROUP BY dealer_id) c ON dealer.id = c.dealer_id;

--g)
SELECT client.name, client.city, dealer.name, dealer.commission
FROM dealer
INNER JOIN
    client ON dealer.id = client.dealer_id;

--h)
SELECT client.name, client.city, dealer.id, dealer.name, dealer.commission
FROM client
INNER JOIN dealer ON  dealer.id = client.dealer_id
WHERE commission > 0.13;


--i)
SELECT client.name, client.city, sell.id, sell.date, sell.amount, dealer.name, dealer.commission
FROM client
LEFT JOIN sell ON sell.client_id = client.id
LEFT JOIN dealer ON sell.dealer_id = dealer.id
ORDER BY client.name;

--j)
SELECT client.name, client.priority, dealer.name, sell.id, sell.amount
FROM client
LEFT JOIN sell ON sell.client_id = client.id
LEFT JOIN dealer ON  sell.dealer_id = dealer.id
where amount >= 2000 AND priority IS NOT NULL;



-- 2)
--а)
CREATE OR REPLACE VIEW uniq_client
AS
    SELECT COUNT(*), AVG(amount), SUM(amount), sell.date
    FROM sell
    INNER JOIN client c on sell.client_id = c.id
    GROUP BY sell.date;

-- drop view uniq_client;
SELECT * FROM uniq_client;

--b)
CREATE OR REPLACE VIEW top5_sell
AS
    SELECT date
    FROM sell
    GROUP BY date
    ORDER BY SUM(amount) DESC
    LIMIT 5;

SELECT * FROM top5_sell;


--c)
CREATE OR REPLACE VIEW view_c
AS
    SELECT dealer_id, COUNT(*), AVG(amount) as avg, SUM(amount) as total
    FROM sell
    INNER JOIN dealer  on sell.dealer_id = dealer.id
    GROUP BY dealer_id;
-- drop view view_c;
SELECT * FROM view_c;

--d)
CREATE OR REPLACE VIEW del_earned_commission
AS
    SELECT dealer.id, (SUM(amount) * dealer.commission) as earned_commission, dealer.location
    FROM sell
    INNER JOIN dealer ON dealer.id = sell.dealer_id
    GROUP BY dealer.location, dealer.id;

-- drop view del_earned_commission;
SELECT * FROM del_earned_commission;


--e)
CREATE OR REPLACE VIEW view_e
AS
    SELECT COUNT(*) as num_of_sales, AVG(amount) as average, SUM(amount) as total, dealer.location
    FROM sell
    INNER JOIN  dealer ON  dealer.id = sell.dealer_id
    GROUP BY dealer.id, dealer.location;

SELECT * FROM view_e;

--f)
CREATE OR REPLACE VIEW view_f
AS
    SELECT client.city, COUNT(*) as num_of_sales, AVG(amount) as average, SUM(amount) as total
    FROM sell
    INNER JOIN client  on sell.client_id = client.id
    GROUP BY client.city;

SELECT * FROM view_f;

--g)
CREATE OR REPLACE VIEW view_g
AS
    SELECT t1.city, t1.t_city, t2.t_loc
    FROM (SELECT SUM(amount) as t_city, city
          FROM sell
          INNER JOIN client c ON sell.client_id = c.id
          GROUP BY c.city) t1
    INNER JOIN (SELECT SUM(amount) as t_loc, location
                FROM sell
                INNER JOIN dealer d ON sell.dealer_id = d.id
                GROUP BY d.location) t2
    ON t1.city = t2.location
    WHERE t1.t_city > t2.t_loc ;


SELECT * FROM view_g;