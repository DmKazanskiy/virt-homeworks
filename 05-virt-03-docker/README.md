
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

---

> 
> Для выполнения задачи выбран образ c nginx: `yobasystems/alpine-nginx:stable` ;
> Подготовлен файл `index.html` содержащий заданный HTML-код;
> Подготовлен `Dockerfile` файл со следующим содержимым:
```
FROM yobasystems/alpine-nginx:stable
COPY ./index.html /etc/nginx/html
EXPOSE 80
```
> С помощью команды `docker build -t dmkazanskii/05-virt-03-docker . ` собран docker-образ;
> С помощью команды `docker run -p 80:80 dmkazanskii/05-virt-03-docker` образ запущен, результат работы соотвествует ожиданиям (скриншот ниже):

![](assets/Pasted%20image%2020220203135132.png)

> Выгружаем `Docker-образ` в публичный реестр:
```
docker-fork$ docker login -u dmkazanskii
Password:
...
docker-fork$ docker push dmkazanskii/05-virt-03-docker
Using default tag: latest
The push refers to repository [docker.io/dmkazanskii/05-virt-03-docker]
83e388e226cf: Pushed 
976cd531e5a4: Mounted from yobasystems/alpine-nginx 
353e0bcc6803: Mounted from yobasystems/alpine-nginx 
e185eadea3a8: Mounted from yobasystems/alpine-nginx 
72e830a4dff5: Mounted from yobasystems/alpine-nginx 
latest: digest: sha256:0130645a07e71ab4f27aa2700a002e149ebd300c29f2c04101f4565fb2c9f3e4 size: 1362

```
> 
> Cозданный форк опубликован в своем репозитории:
> https://hub.docker.com/r/dmkazanskii/05-virt-03-docker
>  


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение:
> Для сценария требуется физический сервер, т.к. для нагруженного монолита  необходим физический доступ к ресурсами.
> 
- Nodejs веб-приложение:
> Для сценария подходит Docker контейнер - возможные требования к ресурсам и интеграциям укладываются в такую реализацию. Графический интерфейс не нужен.
> 
- Мобильное приложение c версиями для Android и iOS:
> Для сценария подходит виртуальная машина - требуется Графический интерфейс.
> 
- Шина данных на базе Apache Kafka:
> Для сценария подходит Виртуальная машина/Docker с подключаемыми Томами хранения сообщений топиков.
> 
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana:
> Для сценария подходят Виртуальные машины - надежность и отказоустойчивость обеспечивается на кластера
> 
- Мониторинг-стек на базе Prometheus и Grafana:
> Для сценария подходит Docker - нет требований к хранению данных
> 
- MongoDB, как основное хранилище данных для java-приложения:
> Для сценария подходит виртуальная машина - требуется хороший уровень надежности хранения данных. 
> 
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry:
> Для сценария подойдет Docker - требование по хранению данных (образов) реализуется с помощью подключаемых Томов.
> 


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.
---

> Создаем папку `/data` в текущей рабочей директории: `mkdir ~/tmp/data`;
> Загружаем минимальный образы centos и debian:
```
docker pull bitnami/centos-extras-base

docker pull bitnami/minideb:latest

```
> Запускаем загруженные образы, подключив папку хоста и устанавливаем "дружелюбное" имя:
```
sudo docker run -v ~/tmp/data:/media/data --name centos -td bitnami/centos-extras-base 

sudo docker run -v ~/tmp/data:/media/data --name minideb -td bitnami/minideb 

```
> Подключаемся к контейнеру `centos` и создаем текстовые файлы с любым содержанием:
```
docker exec centos /bin/bash -c "touch /media/data1/cent-{10..19}.txt && echo Netology | tee -a /media/data1/cent-{10..19}.txt"
```
>   Добавляем еще один файл в папку `~/tmp/data` на хостовой машине:
```
sudo touch ~/tmp/data/host-20.txt
```
>   Подключаемся к контейнеру `minideb`  и отображаем список файлов папки `/media/data` контейнера:
```
docker exec minideb /bin/bash -c "ls -lah /media/data"

total 48K
drwxr-xr-x 2 root root 4.0K Feb  5 17:30 .
drwxr-xr-x 1 root root 4.0K Feb  4 17:47 ..
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-10.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-11.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-12.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-13.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-14.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-15.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-16.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-17.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-18.txt
-rw-r--r-- 1 root root    9 Feb  5 17:30 cent-19.txt
-rw-r--r-- 1 root root    0 Feb  5 17:30 host-20.txt


```
---

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
> 
> 
```
virt-homeworks/05-virt-03-docker/src/build/ansible$ docker build -t dmkazanskii/ansible:2.9.24 .

...

virt-homeworks/05-virt-03-docker/src/build/ansible$ docker image ls

 REPOSITORY                   TAG       IMAGE ID       CREATED          SIZE
 dmkazanskii/ansible          2.9.24    e8fa2d04d81a   58 seconds ago   230MB
virt-homeworks/05-virt-03-docker/src/build/ansible$ docker push dmkazanskii/ansible:2.9.24

The push refers to repository [docker.io/dmkazanskii/ansible]
947af2b316f6: Pushed 
08f6a945f14a: Pushed 
1a058d5342cc: Mounted from library/alpine 
2.9.24: digest: sha256:ed347f1e6bd24f918b4ed671a4f4803b6cae28dd59686aa1bacdb8588430d1c6 size: 947

```
> Cозданный форк опубликован в своем репозитории:
> https://hub.docker.com/repository/docker/dmkazanskii/ansible
>  
---
