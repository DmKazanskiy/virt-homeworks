# provider.tf
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "netology"
  region                  = "eu-central-1"
}
