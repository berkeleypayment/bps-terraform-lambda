locals {
  enable_bucket_trigger_count = var.enable_bucket_trigger ? 1 : 0
}

resource "aws_s3_bucket_notification" "default" {
  count  = local.enable_bucket_trigger_count
  bucket = var.bucket_name
  lambda_function {
    lambda_function_arn = aws_lambda_function.default.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.bucket_filter_prefix
    filter_suffix       = var.bucket_filter_suffix

  }
  depends_on = [
    aws_lambda_function.default
  ]
}
resource "aws_lambda_permission" "default" {
  count         = local.enable_bucket_trigger_count
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
  depends_on = [
    aws_lambda_function.default
  ]
}


