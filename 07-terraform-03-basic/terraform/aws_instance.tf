# aws_instance.tf
locals {
  env = {
    default = {
      instance_type  = "t2.micro"
      ami            = "ami-09439f09c55136ecf"
      instance_count = 1
      }
    stage = {
      instance_type  = "t2.micro"
      ami            = "ami-09439f09c55136ecf"
      instance_count = 1
    }
    prod = {
      instance_type  = "t2.micro"
      ami            = "ami-09439f09c55136ecf"
      instance_count = 2
    }
  }
  environmentvars    = "${contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"}"
  workspace          = "${merge(local.env["default"], local.env[local.environmentvars])}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.s3_bucket_prefix}-aws-vpc"
  }
}

resource "aws_instance" "ec2-cloud" {
    ami = "${local.workspace["ami"]}"
    instance_type = "${local.workspace["instance_type"]}"
    count = "${local.workspace["instance_count"]}"
    tags = {
      Name = "netology-${count.index}"
    }
    lifecycle {
      create_before_destroy = true
    }
}



locals {
  buckets_id = toset([
    "e1",
    "e2",
  ])
}

resource "aws_s3_bucket" "bucket-cloud" {
  for_each = local.buckets_id
  bucket = "${var.s3_bucket_prefix}-${each.key}-${terraform.workspace}"
  tags = {
    Name        = "${var.s3_bucket_prefix} ${each.key}"
    Environment = terraform.workspace
  }
}