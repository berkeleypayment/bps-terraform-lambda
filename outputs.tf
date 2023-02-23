output "s3_bucket" {
  value = var.bucket_name

}
output "lambda_arn" {
  value = aws_lambda_function.default.arn
}

output "role_name" {
  value = aws_iam_role.lambda.name
}

output "role_arn" {
  value = aws_iam_role.lambda.arn
}