provider "aws" {
        profile = "netology"
}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  instance_count = {
  stage = 1
  prod = 2
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "${var.bucket_name}-${count.index}-${terraform.workspace}"
  tags = {
    Name        = "Bucket ${count.index}"
    Environment = terraform.workspace
  }
  count = local.instance_count[terraform.workspace]
}

locals {
  backets_ids = toset([
    "e1",
    "e2",
  ])
}
resource "aws_s3_bucket" "b_e" {
  for_each = local.backets_ids
  bucket = "n${var.bucket_name}-${each.key}-${terraform.workspace}"
  tags = {
    Name        = "Bucket ${each.key}"
    Environment = terraform.workspace
  }
}
resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b[count.index].id
  acl    = "private"
  count = local.instance_count[terraform.workspace]
}

resource "aws_s3_bucket_versioning" "b-versions" {
  bucket = aws_s3_bucket.b[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
  count = local.instance_count[terraform.workspace]
}


resource "aws_s3_bucket_policy" "b" {  
  bucket = aws_s3_bucket.b[count.index].id   
  count = local.instance_count[terraform.workspace]
  policy = <<POLICY
  {    
    "Version": "2012-10-17",    
    "Statement": [        
      {
        "Sid": "ListObject", 
        "Effect": "Allow",            
        "Principal": "*",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.b[count.index].id}"
      },{            
        "Sid": "GetPutDeleteObject",            
        "Effect": "Allow",            
        "Principal": "*",            
        "Action": [                
           "s3:GetObject", "s3:PutObject", "s3:DeleteObject"           
        ],            
        "Resource": [
           "arn:aws:s3:::${aws_s3_bucket.b[count.index].id}/*"            
          ]        
      }    
    ]
  }
  POLICY
}

resource "aws_s3_bucket_policy" "b_e" {  
  for_each = local.backets_ids
  bucket = aws_s3_bucket.b_e[each.key].id
  policy = <<POLICY
  {    
    "Version": "2012-10-17",    
    "Statement": [        
      {
        "Sid": "ListObject", 
        "Effect": "Allow",            
        "Principal": "*",
        "Action": "s3:ListBucket",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.b_e[each.key].id}"
      },{            
        "Sid": "GetPutDeleteObject",            
        "Effect": "Allow",            
        "Principal": "*",            
        "Action": [                
           "s3:GetObject", "s3:PutObject", "s3:DeleteObject"           
        ],            
        "Resource": [
           "arn:aws:s3:::${aws_s3_bucket.b_e[each.key].id}/*"            
          ]        
      }    
    ]
  }
  POLICY
}