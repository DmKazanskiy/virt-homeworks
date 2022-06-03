# main.tf

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  tags = {
    Name        = "netology-7-03-bucket"
    Environment = "Dev"
  }
  object_lock_enabled = true
}

resource "aws_s3_bucket_acl" "b" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "b" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = var.dinamo_table_name
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}

resource "aws_s3_bucket_policy" "b" {  
  bucket = aws_s3_bucket.b.id   
  policy = <<POLICY
  {    
    "Version": "2012-10-17",    
    "Statement": [        
      {
        "Sid": "ListObject", 
        "Effect": "Allow",            
        "Principal": "*",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.b.id}"
      },{            
        "Sid": "GetPutDeleteObject",            
        "Effect": "Allow",            
        "Principal": "*",            
        "Action": [                
           "s3:GetObject", "s3:PutObject", "s3:DeleteObject"           
        ],            
        "Resource": [
           "arn:aws:s3:::${aws_s3_bucket.b.id}/*"            
          ]        
      }    
    ]
  }
  POLICY
}

