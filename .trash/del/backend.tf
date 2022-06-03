# versions.tf
terraform {
  backend "s3" {
    key            = "path/to/my/key"
    bucket         = "netology-bckt-01"
    dynamodb_table = "netology-bckt-02_table"
    region         = "eu-central-1"
  }
}
