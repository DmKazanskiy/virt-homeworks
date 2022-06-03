# provider.tf
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "netology"
  region                  = "eu-central-1"
}
