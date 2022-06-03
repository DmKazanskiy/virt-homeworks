# variable.tf
variable "bucket_name" {
  type = string
  default = "ru.netology.terraform"
}

variable "dinamo_table_name" {
  type = string
  default = "netology_terraform_state-703"
}

variable "acl_value" {
  default = "private"
}

variable "s3_bucket_prefix" {
  type = string
  default = "ru.netology.terraform-703"
}
variable "s3_region" {
  type = string
  default = "eu-central-1"
}