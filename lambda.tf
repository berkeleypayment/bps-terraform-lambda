resource "aws_lambda_function" "default" {
  function_name    = "${var.namespace}-${var.stage}-${var.service}-${var.function_name}"
  role             = aws_iam_role.lambda.arn
  handler          = var.handler_filename
  runtime          = var.runtime
  timeout          = 3
  source_code_hash = filebase64sha256(data.archive_file.default.output_path)
  filename         = data.archive_file.default.output_path
  memory_size      = var.memory_size

  package_type = "Zip"
  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }
  layers = var.layers

  dynamic "environment" {
    for_each = var.environment != null ? [var.environment] : []
    content {
      variables = environment.value.variables
    }
  }


  depends_on = [
    aws_iam_role.lambda,
    data.archive_file.default
  ]

  tags = merge(
    var.default_tags
  )


}
resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${aws_lambda_function.default.function_name}"
  retention_in_days = var.log_retention_days

  tags = merge(
    var.default_tags
  )
}



resource "random_uuid" "default" {
  keepers = {
    filelist = var.random_keeper_id
  }
}


data "archive_file" "default" {
  type        = "zip"
  source_dir  = var.lambda_src_path
  output_path = "${random_uuid.default.result}.zip"

  depends_on = [random_uuid.default]
  excludes   = var.zip_exclude_list
}


