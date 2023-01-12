output "s3_bucket" {
  value = var.bucket_name

}
output "lambda_arn" {
  value = aws_lambda_function.default.arn
}
