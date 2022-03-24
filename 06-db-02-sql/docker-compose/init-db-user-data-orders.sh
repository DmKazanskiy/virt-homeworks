#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER "test-admin-user";
	CREATE DATABASE test_db ENCODING "UTF-8";
	GRANT CONNECT ON DATABASE test_db to "test-admin-user";

	\c test_db;

	CREATE TABLE IF NOT EXISTS orders (
	id serial PRIMARY KEY, 
	name text, 
	price integer 
	);

	CREATE TABLE IF NOT EXISTS clients (
		id serial PRIMARY KEY,
		lastname text,
		country text,
		order_num integer,
		FOREIGN KEY (order_num) REFERENCES orders (Id)
	);

	CREATE INDEX ON clients(country);

	GRANT ALL PRIVILEGES ON DATABASE test_db TO "test-admin-user";
	GRANT ALL PRIVILEGES ON clients, orders TO "test-admin-user"; 


	CREATE ROLE "test-simple-user";
	GRANT CONNECT ON DATABASE test_db to "test-simple-user";
	GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.clients TO "test-simple-user";
	GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.orders TO "test-simple-user";

	INSERT INTO orders (name,price)
	VALUES ('Шоколад',10),('Принтер',3000),('Книга',500),('Монитор',7000),('Гитара',4000)
	ON CONFLICT (id) DO NOTHING;

	INSERT INTO clients (lastname,country) 
	VALUES ('Иванов Иван Иванович','USA'),('Петров Петр Петрович','Canada'),('Иоганн Себастьян Бах','Japan'),('Ронни Джеймс Дио','Russia'),('Ritchie Blackmore','Russia')
	ON CONFLICT (id) DO NOTHING;

	UPDATE clients SET order_num=(select id from orders where name like 'Книга') where id=(select id from clients where lastname like 'Иванов Иван Иванович');
	UPDATE clients SET order_num=(select id from orders where name like 'Монитор') where id=(select id from clients where lastname like 'Петров Петр Петрович');
	UPDATE clients SET order_num=(select id from orders where name like 'Гитара') where id=(select id from clients where lastname like 'Иоганн Себастьян Бах');
EOSQL