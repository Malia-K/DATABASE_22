--4
SELECT * FROM packs;

-- 5
SELECT * FROM packs
WHERE value > 190;

--6
SELECT DISTINCT contents FROM packs;


--7
SELECT warehouses.code, COUNT(packs.warehouses) FROM warehouses, packs
WHERE warehouses.code = packs.warehouses
GROUP BY  packs.warehouses, warehouses.code
order by warehouses.code;

--8
SELECT warehouses.code, COUNT(packs.warehouses) FROM warehouses, packs
WHERE warehouses.code = packs.warehouses
GROUP BY  packs.warehouses, warehouses.code
HAVING COUNT(packs.warehouses) > 2
order by warehouses.code;

--9
INSERT INTO warehouses(code, location, capacity)
VALUES(6, 'Texas', 5);

--10
INSERT INTO packs(code, contents, value, warehouses)
VALUES('H5RT', 'Papers', 150, 2);

--11

-- SELECT value from packs
--     ORDER BY value desc
-- ;

UPDATE packs
SET value = value - value * 0.18
WHERE value = (SELECT value from packs
       ORDER BY value desc
       OFFSET 2
       LIMIT 1);

--12

SELECT * FROM packs;

DELETE FROM packs
WHERE value < 150;

--13
DELETE FROM packs
WHERE warehouses in(
    SELECT code from warehouses
    where location = 'Chicago')
returning *;