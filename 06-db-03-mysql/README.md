# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
* [дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).
* [дополнительные ссылки](links-useful.md)
## Решение Задач 
Решение задач (ниже) выполнил с помощью [docker-compose файла](test_data/docker-compose.yml).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](test_data/test_dump.sql) и восстановитесь из него.

> 
> задание выполнено с помощью инструкции копирования `test-dump.sql` в директорию `docker-entrypoint-initdb.d` с именем `01.sql` при развертывании контейнера.
> строка 23 [docker-compose файла](test_data/docker-compose.yml).
> 

**Перейдите в управляющую консоль `mysql` внутри контейнера.**

```
docker exec -it $(docker ps -q) mysql -u root --password=admin test_db

```

**Используя команду `\h` получите список управляющих команд.**

```
mysql> \h
...
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'

```

**Найдите команду для выдачи статуса БД** и **приведите в ответе** из ее вывода версию сервера БД.
```
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		10
Current database:	test_db
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			3 min 50 sec

Threads: 3  Questions: 183  Slow queries: 0  Opens: 198  Flush tables: 3  Open tables: 117  Queries per second avg: 0.795
--------------

```

**Подключитесь к восстановленной БД и получите список таблиц из этой БД.**

```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.01 sec)

mysql> use test_db;
Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

```

**Приведите в ответе количество записей с `price` > 300.**
```
mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.01 sec)

```

В следующих заданиях мы будем продолжать работу с данным контейнером.



## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

**Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.**

> 
> задание выполнено с помощью инструкции копирования [test-user-task2.sql](test-data/test-user-task2.sql) в директорию `docker-entrypoint-initdb.d` с именем `02.sql` при развертывании контейнера.
> строка 24 [docker-compose файла](test_data/docker-compose.yml).
> 

```
ALTER USER "test"
	  WITH MAX_QUERIES_PER_HOUR 100
	  PASSWORD EXPIRE INTERVAL 180 DAY
	  FAILED_LOGIN_ATTEMPTS 3
	  ATTRIBUTE '{"fname":"Pretty","lname":"James"}';
REVOKE ALL PRIVILEGES ON *.* FROM test;
GRANT SELECT ON test_db.* TO "test";
FLUSH PRIVILEGES;
```
    
**Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и  приведите в ответе к задаче**.

```
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+------+---------------------------------------+
| USER | HOST | ATTRIBUTE                                            |
+------+------+---------------------------------------+
|  test   |  %      | {"fname": "Pretty", "lname": "James"}   |
+------+------+---------------------------------------+
1 row in set (0.01 sec)
```

## Задача 3

**Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.**

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

```

**Исследуйте, какой `engine` используется в таблице БД `test_db` и  приведите в ответе**.

```
mysql> SELECT TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH,INDEX_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
+------------+--------+------------+------------+-------------+--------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH | INDEX_LENGTH |
+------------+--------+------------+------------+-------------+--------------+
| orders     | InnoDB | Dynamic    |          5 |       16384 |            0 |
+------------+--------+------------+------------+-------------+--------------+
1 row in set (0.01 sec)

```

**Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.04 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
| Query_ID | Duration   | Query                                                                                                                                                                                |       1  | 0.03997625 | ALTER TABLE orders ENGINE = MyISAM
|       2  | 0.05256775 | ALTER TABLE orders ENGINE = InnoDB
2 rows in set, 1 warning (0.00 sec)

```
> 
> Время переключения InnoDB -> MyISAM = 0.03997625
> Время обратного переключения MyISAM -> InnoDB выше: 0.05256775
> 

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

**Приведите в ответе измененный файл `my.cnf`.**

> 
> задание выполнено с помощью инструкции копирования [my.cnf](/test_data/docker-etc/my.cnf)mp.sql в директорию `/etc/mysql/conf.d/` с именем `mysqld.cnf` при развертывании контейнера.
> строка 22 [docker-compose файла](test_data/docker-compose.yml).

```
[mysqld]

# Set IO Speed
# 0 - буфер сбрасывается в лог файл независимо от транзакций (риск потери данных)
# 1 - любая завершенная транзакция будет синхронно сбрасывать лог на диск. Вариант по-умолчанию
# 2 - любая завершенная транзакция будет синхронно сбрасывать лог в оперативную память
innodb_flush_log_at_trx_commit = 0 

# Set compression
innodb_compression_level = 6

# Set buffer
# размер буфера транзакций, которые еще не были закоммичены
innodb_log_buffer_size	= 1M

# Set Cache size
# размер памяти, для хранения данных и индексов таблиц с типом InnoDB
innodb_buffer_pool_size = 640M

# Set innodb_log_file_size
# размер файла лога операций
innodb_log_file_size = 100M

```

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
