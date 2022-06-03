data "terraform_remote_state" "config" {
  backend = "s3"

  config {
    bucket     = "${var.s3bucket}"
    key        = "terraform.tfstate"
    region     = "${var.region}"
    profile    = "netology"
    encrypt    = true
  }
}

terraform {
  backend "s3" {
    bucket   = "ru.netology.terraform"
    key      = "terraform.tfstate"
    region   = "eu-central-1"
    profile  = "netology"
    encrypt  =  true
  }
}