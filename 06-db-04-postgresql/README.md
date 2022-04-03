# Домашнее задание к занятию "6.4. PostgreSQL"
## Решение Задач 
Решение задач (ниже) выполнил с помощью [docker-compose файла](test_data/docker-compose.yml).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

> 
> строка 7 [docker-compose файла](test_data/docker-compose.yml)
> 


Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
postgres=# \l
```
- подключения к БД
```
postgres=# \c <Наименование БД>
```
- вывода списка таблиц
```
postgres=# \dt 
```
- вывода описания содержимого таблиц
```
postgres=# \d <Наименование Таблицы>
```
- выхода из psql
```
postgres=# \q
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
> 
> задание выполнено с помощью инструкции копирования `test-dump.sql` в директорию `docker-entrypoint-initdb.d` с именем `dump.sql` при развертывании контейнера.
> 
> строка 16 [docker-compose файла](test_data/docker-compose.yml).
> 


Перейдите в управляющую консоль `psql` внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат

> Переход в управляющую консоль внутри контейнера:

```
06-db-04-postgresql/test_data$ docker exec -it $(docker ps -q) psql --username=postgres --dbname=postgres

psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
---------------+----------+----------+------------+------------+--------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)
```
```
postgres=# \c test_database;
You are now connected to database "test_database" as user "postgres".
test_database=# \dt
          List of relations
 Schema |   Name   | Type  |  Owner   
--------+----------+-------+----------
 public | orders   | table | postgres
(1 row)

```

> Выполнение операции `ANALYZE` для сбора статистики по таблице `orders`:

```
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

> столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах:

```
test_database=# select attname, avg_width from pg_stats where tablename='orders' order by avg_width desc limit 1; 

 attname | avg_width 
---------+-----------
 title   |        16
(1 row)


```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции:

```
# Переименовываем текущую и создаем аналогичную таблицу
alter table orders rename to orders_tmp;  
create table orders as (select * from orders_tmp) with no data;  

# Создаем партиции и правила переобпределяющие таблицу назначения при вставке, с раделением наборов данных по полю `price`
create table orders_1 (check (price>499)) inherits (orders);  
create table orders_2 (check (price<=499)) inherits (orders);  
create rule orders_1_insert As on insert to orders where (price>499) do instead insert into orders_1 values (new.*);  
create rule orders_2_insert As on insert to orders where (price<=499) do instead insert into orders_2 values (new.*);  

# Добавляем данные в новую структуру из копии и удаляем временную таблицу  
insert into orders (id, title, price) select * from orders_tmp;
drop table orders_simple;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

> Да, можно - при проектировании структуры хранения, на этапе расчета ресурсов, можно сформулировать требование по секционированию. 
> 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
06-db-04-postgresql/test_data$ docker exec -it $(docker ps -q) bash

root@9a61e7508379:/# cd /var/lib/postgresql/data

root@9a61e7508379:/var/lib/postgresql/data# pg_dump -U postgres -d test_database >test_database_dump.sql

root@9a61e7508379:/var/lib/postgresql/data# ls -lah
total 136K
drwx------ 19 postgres root     4.0K Apr  3 18:15 .
drwxr-xr-x  1 postgres postgres 4.0K Mar 29 04:40 ..
drwx------  6 postgres postgres 4.0K Apr  3 17:32 base
drwx------  2 postgres postgres 4.0K Apr  3 17:32 global
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_commit_ts
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_dynshmem
-rw-------  1 postgres postgres 4.7K Apr  3 17:32 pg_hba.conf
-rw-------  1 postgres postgres 1.6K Apr  3 17:32 pg_ident.conf
drwx------  4 postgres postgres 4.0K Apr  3 17:57 pg_logical
drwx------  4 postgres postgres 4.0K Apr  3 17:32 pg_multixact
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_notify
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_replslot
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_serial
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_snapshots
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_stat
drwx------  2 postgres postgres 4.0K Apr  3 18:15 pg_stat_tmp
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_subtrans
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_tblspc
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_twophase
-rw-------  1 postgres postgres    3 Apr  3 17:32 PG_VERSION
drwx------  3 postgres postgres 4.0K Apr  3 17:32 pg_wal
drwx------  2 postgres postgres 4.0K Apr  3 17:32 pg_xact
-rw-------  1 postgres postgres   88 Apr  3 17:32 postgresql.auto.conf
-rw-------  1 postgres postgres  28K Apr  3 17:32 postgresql.conf
-rw-------  1 postgres postgres   36 Apr  3 17:32 postmaster.opts
-rw-------  1 postgres postgres   94 Apr  3 17:32 postmaster.pid
-rw-r--r--  1 root     root     2.4K Apr  3 18:15 test_database_dump.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

> чтобы добавить уникальность значения столбца можно добавить индекс:
```
CREATE INDEX ON orders ((lower(title)));
```


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
