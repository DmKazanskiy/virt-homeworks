/*output "instance_name" {
  description = "Наименование EC2"
  value       = aws_instance.web.ami
}*/
#data "aws_caller_identity" "current" {}

output "account_id" {
  description = "AWS account ID"
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  description = "AWS user ID"
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  description = "AWS регион, который используется в данный момент"
  value       = data.aws_region.current.name
}

output "private_ips" {
description = "Приватный IP ec2 инстансы"
value       = aws_instance.web.*.private_ip
}

output "subnet_id" {
  description = "Идентификатор подсети в которой создан инстанс"
  value       = aws_instance.web.subnet_id
}

output "instance_id" {
  description = "Идентификатор EC2"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Публичный адрес EC2 "
  value       = aws_instance.web.public_ip
}