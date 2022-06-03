# variable.tf
variable "bucket_name" {
  type = string
  default = "ru.netology.s3.state"
}

variable "dinamo_table_name" {
  type = string
  default = "ru_netology_dynamodb_lock"
}

variable "acl_value" {
  default = "private"
}