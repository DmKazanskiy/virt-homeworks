# variable.tf
variable "s3bucket" {
  type = string
  default = "ru.netology.terraform"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "dinamo_table_name" {
  type = string
  default = "netology_terraform_state_703"
}

variable "acl_value" {
  default = "private"
}