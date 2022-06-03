# main.tf

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "netology-bckt-01"
    key    = "network/terraform.tfstate"
    region = "eu-central-1"
  }
}


data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

