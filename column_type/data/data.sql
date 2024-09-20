DROP TABLE IF EXISTS boats;
DROP TABLE IF EXISTS cars;

CREATE TABLE boats (id serial primary key, price numeric(7,2) default 3.14);
CREATE TABLE cars (id serial primary key, price numeric(7,2) default 3.14 );

INSERT INTO boats (id) values (generate_series(1,3*10e3,1));
INSERT INTO cars (id) values (generate_series(1,10e6,1));
