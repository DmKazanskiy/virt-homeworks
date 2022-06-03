# backend.tf
/* toogle uncomment this instructions before start workspaces */
terraform {
  backend "s3" {
  bucket = "ru.netology.terraform-703"
  key = "terraform.tfstate"
  dynamodb_table = "netology_terraform_state-703"
  profile        = "netology"
  region         = "eu-central-1"
  encrypt        = true
  }
}
/**/
/* comment this up-instuctions before destroy IAC */
