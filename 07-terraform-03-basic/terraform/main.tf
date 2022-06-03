# main.tf
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "main" {
  bucket = "${var.s3_bucket_prefix}"
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "versioning_enable" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "aes256" {
  bucket = aws_s3_bucket.main.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "${var.dinamo_table_name}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "aws_s3_bucket_policy" "policy" {  
  bucket = aws_s3_bucket.main.id   
  policy = <<POLICY
  {    
    "Version": "2012-10-17",    
    "Statement": [        
      {
        "Sid": "ListObject", 
        "Effect": "Allow",            
        "Principal": "*",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.main.id}"
      },{            
        "Sid": "GetPutDeleteObject",            
        "Effect": "Allow",            
        "Principal": "*",            
        "Action": [                
           "s3:GetObject", "s3:PutObject", "s3:DeleteObject"           
        ],            
        "Resource": [
           "arn:aws:s3:::${aws_s3_bucket.main.id}/*"            
          ]        
      }    
    ]
  }
  POLICY
}

