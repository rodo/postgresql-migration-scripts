DROP TABLE IF EXISTS boats;
DROP TABLE IF EXISTS cars;
drop function IF EXISTS boats_migr01_trg ;
drop function IF EXISTS cars_migr01_trg ;


CREATE TABLE boats (id serial primary key, price numeric(7,2) default 3.14,
discount_price numeric(7,2),alpha int);

CREATE TABLE cars (id serial primary key, price numeric(7,2) default 3.14, alpha int );

INSERT INTO boats (alpha) values (generate_series(1,3*10e3,1));
INSERT INTO cars (alpha) values (generate_series(1,10e4,1));
