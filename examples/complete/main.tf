module "simple" {
  source = "../.."
  
  stage = var.stage
  namespace = var.namespace
  service = var.service
  
  bucket_filter_suffix ="file.csv"

  handler_filename = "index.handler"
  function_name = "s3test"

  random_keeper_id = "dsadsa"
  bucket_name = ""
  lambda_src_path = "${path.cwd}/../src/"
   enable_bucket_trigger = true
   enable_rds_s3import = true
}


resource "random_string" "default" {
  length  = 5
  special = false
  upper   = false
}


resource "aws_s3_bucket" "default" {
  bucket        = "${var.namespace}-${var.stage}-${var.service}-${random_string.default.result}"
}


resource "aws_s3_bucket_public_access_block" "default" {
  
  bucket =  aws_s3_bucket.default.bucket 

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket =  aws_s3_bucket.default.bucket 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}