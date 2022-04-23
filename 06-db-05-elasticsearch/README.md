# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

> [Для сборки контейнера использовал описание
 раздела "ElasticSearch with Docker"](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html) 
 
>
> ссылка на текст [DockerFile](06-db-05-elasticsearch/centos-elastic/Dockerfile) 
> 
> ссылка на образ [в репозитории dockerhub](https://hub.docker.com/r/dmkazanskii/elasearch) 
> 
> ответ в json виде:
```bash
# Скопировал сертификат http_ca.crt на локальную машину:
\# docker cp crazy_bouman:/etc/elasticsearch/certs/http_ca.crt .

# Проверка ответ elasticsearch
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI https://localhost:9200
```
> 
> Ответ системы:
```json
{
  "name" : "netology_test",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "e2HgGCR8R6uyC5VcF_-SxQ",
  "version" : {
    "number" : "8.1.2",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "31df9689e80bad366ac20176aa7f2371ea5eb4c1",
    "build_date" : "2022-03-29T21:18:59.991429448Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

```
> ссылка на  [generated password for the elastic built-in superuser ](user_secrets_elasticsearch.md)
> 
## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
>
> 
```bash
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X PUT "https://localhost:9200/ind-1" -H "Content-Type: application/json" -d'{ "settings": { "index": {"number_of_shards": 1,  "number_of_replicas": 0 }}}'

{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X PUT "https://localhost:9200/ind-2" -H "Content-Type: application/json" -d'{ "settings": { "index": {"number_of_shards": 2,  "number_of_replicas": 1 }}}'

{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X PUT "https://localhost:9200/ind-3" -H "Content-Type: application/json" -d'{ "settings": { "index": {"number_of_shards": 4,  "number_of_replicas": 2 }}}'

{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1 ztWeyhjuRTCESrBQwYrAIw   1   0          0            0       225b           225b
yellow open   ind-3 GbcudSRGQ-O0iF0ILGmqRQ   4   2          0            0       900b           900b
yellow open   ind-2 D4hMgAccRp6IiytQKY505g   2   1          0            0       450b           450b

```
> 
> Статус индекса `ind-1`:

```bash
06-db-05-elasticsearch/centos-elastic# 
curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cluster/health/ind-1?pretty"

{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}


```
> 
> Статус индекса `ind-2`:
```bash
curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cluster/health/ind-2?pretty"
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 52.38095238095239
}

```
> 
> Статус индекса `ind-3`:
```bash
\#curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cluster/health/ind-3?pretty"
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 52.38095238095239
}

```
> Статус кластера:
>
```bash
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cluster/health/?pretty=true"
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 11,
  "active_shards" : 11,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 52.38095238095239
}

```
>
>Удаление индексов:
```bash
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X DELETE "https://localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X DELETE "https://localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X DELETE "https://localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cat/indices?v"
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size

```


## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

> 
> Регистрация директории как `snapshot repository`
> 
```bash
# добавил параметр в elasticsearch.yml: 
# 'path.repo: /usr/share/elasticsearch/snapshots' и скопировал конфиг в контейнер
\# docker container cp ./elasticsearch.yml crazy_bouman:/etc/elasticsearch/elasticsearch.yml && docker start -i crazy_bouman

```
>
```bash
# Регистрация `snapshot repository` c именем `netology_backup`:
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -XPOST https://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'

{
  "acknowledged" : true
}

#Проверка результата:
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI https://localhost:9200/_snapshot/netology_backup?pretty

{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -XPUT https://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

{"snapshot":
  {"snapshot":"elasticsearch",
  "uuid":"_9C2BT-hQ7SYOeoLaWT7-w",
  "repository":"netology_backup",
  "version_id":8010299,
  "version":"8.1.2",
  "indices":[".geoip_databases",".ds-ilm-history-5-2022.04.17-000001","test",".ds-.logs-deprecation.elasticsearch-default-2022.04.17-000001",".security-7"],
  "data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],
  "include_global_state":true,
  "state":"SUCCESS",
  "start_time":"2022-04-23T09:55:30.983Z",
  "start_time_in_millis":1650707730983,
  "end_time":"2022-04-23T09:55:31.984Z",
  "end_time_in_millis":1650707731984,
  "duration_in_millis":1001,
  "failures":[],
  "shards":{"total":5,"failed":0,"successful":5},
  "feature_states":[
     {"feature_name":"geoip","indices":[".geoip_databases"]},
     {"feature_name":"security","indices":[".security-7"]}
   ]
  }
}
#
bash-4.2$ ls -lah
total 48K
drwxr-xr-x 1 elasticsearch elasticsearch 4.0K Apr 23 09:55 .
drwxr-xr-x 1 root          root          4.0K Apr 16 13:11 ..
-rw-r--r-- 1 elasticsearch elasticsearch 1.7K Apr 23 09:55 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Apr 23 09:55 index.latest
drwxr-xr-x 7 elasticsearch elasticsearch 4.0K Apr 23 09:55 indices
-rw-r--r-- 1 elasticsearch elasticsearch  19K Apr 23 09:55 meta-_9C2BT-hQ7SYOeoLaWT7-w.dat
-rw-r--r-- 1 elasticsearch elasticsearch  484 Apr 23 09:55 snap-_9C2BT-hQ7SYOeoLaWT7-w.dat

```
>
```bash
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X PUT "https://localhost:9200/test" -H "Content-Type: application/json" -d'{ "settings": { "index": {"number_of_shards": 1,  "number_of_replicas": 0 }}}'

{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
#
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X GET "https://localhost:9200/_cluster/health/test?pretty"

{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}


```
>
```bash
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -XDELETE https://localhost:9200/test?pretty
{
  "acknowledged" : true
}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -X PUT https://localhost:9200/test-2?pretty -H "Content-Type: application/json" -d'{ "settings": { "index": {"number_of_shards": 1,  "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI https://localhost:9200/test-2?pretty
{
  "test-2" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test-2",
        "creation_date" : "1650708406601",
        "number_of_replicas" : "0",
        "uuid" : "Vrd-fS03Qm2IQg8gYfEKKg",
        "version" : {
          "created" : "8010299"
        }
      }
    }
  }
}

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI https://localhost:9200/_cat/indices?pretty

green open test-2 Vrd-fS03Qm2IQg8gYfEKKg 1 0 0 0 225b 225b

\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI -XPOST https://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":false,"ignore_unavailable": true, "rename_pattern": "(.+)", "rename_replacement": "$1_restored","include_aliases": false }'
{
  "accepted" : true
}
\# curl --cacert http_ca.crt -u elastic:h04RjdzaZcp_GxzMFQWI https://localhost:9200/_cat/indices?pretty

green open test_restored LYoN5XzOSaSeC7uovDtQZA 1 0 0 0 225b 225b


```



---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
