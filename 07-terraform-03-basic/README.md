# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).

> 
> 

```bash
07-terraform-03-basic/terraform-aws$ aws configure --profile=netology
AWS Access Key ID [****************IAEE]: 
AWS Secret Access Key [****************VrUc]: 
Default region name [eu-central-1]: 
Default output format [json]: 

```
> 
```bash
07-terraform-03-basic/terraform-aws$ aws iam get-user --user-name=netology
{"User": 
	{"Path": "/",
	"UserName": "netology",
	"UserId": "*****************PDPR",
	"Arn": "arn:aws:iam::********:user/netology",
	"CreateDate": "2022-05-22T17:27:23Z"}
}

```
> 
```bash
07-terraform-03-basic/terraform-aws$ aws iam list-groups-for-user --user-name=netology
{"Groups": [
	{"Path": "/",
	"GroupName": "netology_terraform",
	"GroupId": "****************W3D5R",
	"Arn": "arn:aws:iam::********:group/netology_terraform",
	"CreateDate": "2022-05-23T17:32:13Z"}
]}

```
> 
```bash
07-terraform-03-basic/terraform-aws$ aws iam list-attached-group-policies --group-name=netology_terraform
{"AttachedPolicies": [
	{"PolicyName": "AmazonDMSRedshiftS3Role",
	"PolicyArn": "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"},
	{"PolicyName": "AmazonRDSFullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/AmazonRDSFullAccess"},
	{"PolicyName": "AmazonEC2FullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/AmazonEC2FullAccess"},
	{"PolicyName": "IAMFullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/IAMFullAccess"},
	{"PolicyName": "AmazonS3FullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/AmazonS3FullAccess"},
	{"PolicyName": "CloudWatchFullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/CloudWatchFullAccess"},
	{"PolicyName": "AmazonDynamoDBFullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"},
	{"PolicyName": "AmazonRDSDataFullAccess",
	"PolicyArn": "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"}]
}
```


1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

```bash
/07-terraform-03-basic/terraform-aws$ aws s3 ls

2022-06-03 20:45:29 ru.netology.terraform-703

```
```bash
/07-terraform-03-basic/terraform$ aws dynamodb list-tables
{
    "TableNames": [
        "netology_terraform_state-703"
    ]
}

```

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  

> 
> После создания ресурсов S3, DynamoDB.Table разкомментируем бэкэнд S3, который будет использоваться для хранения состояний 
>

```json
# backend.tf
/* toogle uncomment this instructions before start workspaces */
terraform {
  backend "s3" {
  bucket         = "ru.netology.terraform-703"
  key            = "terraform.tfstate"
  dynamodb_table = "netology_terraform_state-703"
  profile        = "netology"
  region         = "eu-central-1"
  encrypt        = true
  }
}

/* comment this up-instuctions before destroy IAC */

```

```bash
/07-terraform-03-basic/terraform$ terraform init -reconfigure

Initializing the backend...
...
  Enter a value: yes

Releasing state lock. This may take a few moments...
...
```
1. Создайте два воркспейса `stage` и `prod`.
```bash
/07-terraform-03-basic/terraform$ terraform workspace list
  default
* prod
  stage

```

1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.
 > 
 > Результат выполнения Задачи 2 в файле - [aws_instance.tf](terraform/aws_instance.tf)
> 

**В виде результата работы пришлите:**
* Вывод команды `terraform workspace list`.

```bash
/07-terraform-03-basic/terraform$ terraform workspace list
  default
* prod
  stage

```

* Вывод команды `terraform plan` для воркспейса `prod`.  

> 
> Блоки  ` (known after apply)` убрал из вывода команды
> 

```bash
/07-terraform-03-basic/terraform$ terraform plan
data.aws_caller_identity.current: Reading...
data.aws_region.current: Reading...
data.aws_region.current: Read complete after 0s [id=eu-central-1]
data.aws_caller_identity.current: Read complete after 1s [id=613993501620]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_dynamodb_table.terraform_state_lock will be created
  + resource "aws_dynamodb_table" "terraform_state_lock" {
      + billing_mode     = "PROVISIONED"
      + hash_key         = "LockID"
      + name             = "netology_terraform_state-703"
      + read_capacity    = 1
      + write_capacity   = 1

      + attribute {
          + name = "LockID"
          + type = "S"
        }

    }

  # aws_instance.ec2-cloud[0] will be created
  + resource "aws_instance" "ec2-cloud" {
      + ami                                  = "ami-09439f09c55136ecf"
      + get_password_data                    = false
      + instance_type                        = "t2.micro"
      + source_dest_check                    = true
      + tags                                 = {
          + "Name" = "netology-0"
        }
      + tags_all                             = {
          + "Name" = "netology-0"
        }
      + user_data_replace_on_change          = false

    }

  # aws_instance.ec2-cloud[1] will be created
  + resource "aws_instance" "ec2-cloud" {
      + ami                                  = "ami-09439f09c55136ecf"
      + get_password_data                    = false
      + instance_type                        = "t2.micro"
      + tags                                 = {
          + "Name" = "netology-1"
        }
      + tags_all                             = {
          + "Name" = "netology-1"
        }
      + user_data_replace_on_change          = false
    }

  # aws_s3_bucket.bucket-cloud["e1"] will be created
  + resource "aws_s3_bucket" "bucket-cloud" {
      + bucket                      = "ru.netology.terraform-703-e1-prod"
      + force_destroy               = false
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "ru.netology.terraform-703 e1"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "ru.netology.terraform-703 e1"
        }
    }

  # aws_s3_bucket.bucket-cloud["e2"] will be created
  + resource "aws_s3_bucket" "bucket-cloud" {
      + bucket                      = "ru.netology.terraform-703-e2-prod"
      + force_destroy               = false
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "ru.netology.terraform-703 e2"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "ru.netology.terraform-703 e2"
        }

  # aws_s3_bucket.main will be created
  + resource "aws_s3_bucket" "main" {
      + bucket                      = "ru.netology.terraform-703"
      + force_destroy               = false
    }

  # aws_s3_bucket_policy.policy will be created
  + resource "aws_s3_bucket_policy" "policy" {
...
	}

  # aws_s3_bucket_server_side_encryption_configuration.aes256 will be created
  + resource "aws_s3_bucket_server_side_encryption_configuration" "aes256" {
      + bucket = "ru.netology.terraform-703"

      + rule {
          + apply_server_side_encryption_by_default {
              + sse_algorithm = "AES256"
            }
        }
    }

  # aws_s3_bucket_versioning.versioning_enable will be created
  + resource "aws_s3_bucket_versioning" "versioning_enable" {

      + versioning_configuration {
          + status     = "Enabled"
        }
    }

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + cidr_block                           = "10.0.0.0/16"
      + instance_tenancy                     = "default"
      + tags                                 = {
          + "Name" = "ru.netology.terraform-703-aws-vpc"
        }
      + tags_all                             = {
          + "Name" = "ru.netology.terraform-703-aws-vpc"
        }
    }

Plan: 10 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply"
now.
Releasing state lock. This may take a few moments...

```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
