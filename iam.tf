locals {
  enable_rds_count = var.enable_rds_s3import == true ? 1 : 0
}
resource "aws_iam_role" "lambda" {
  path                 = "/"
  name                 = "${var.namespace}-${var.stage}-${var.service}-${var.function_name}"
  max_session_duration = 3600

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(
    var.default_tags
  )
}
resource "aws_iam_role_policy" "lambda" {
  role = aws_iam_role.lambda.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeRouteTables",
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "iam:ListRolePolicies",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "cloudwatch:PutMetricData"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*${var.namespace}-${var.stage}-${var.service}*"
            ]
        }
    ]
}
POLICY
}


resource "aws_iam_role_policy" "lambda_bucket" {
  count = var.bucket_name != null ? 1 :0
  role  = aws_iam_role.lambda.name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:CreateBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
                ]
        }
    ]
}
POLICY
}

data "aws_iam_policy" "lambda_vpc_role" {
  count = var.vpc_config != null ? 1 : 0
  arn   = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_role" {
  count      = var.vpc_config != null ? 1 : 0
  role       = aws_iam_role.lambda.name
  policy_arn = data.aws_iam_policy.lambda_vpc_role[0].arn
}



resource "aws_iam_role" "rds_s3" {
  count                = var.enable_rds_s3import ? 1 : 0
  path                 = "/"
  name                 = "${var.namespace}-${var.stage}-${var.service}-rds-s3-import"
  max_session_duration = 3600

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(
    var.default_tags
  )
}



resource "aws_iam_role_policy" "rds_s3" {
  count = local.enable_rds_count
  role  = aws_iam_role.rds_s3[0].name

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:AbortMultipartUpload",
                "s3:DeleteObject",
                "s3:ListMultipartUploadParts",
                "s3:PutObject",
                "s3:ListBucket"
            ],
             "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
            }
        ]
}
POLICY
}


resource "aws_rds_cluster_role_association" "s3import" {
  count                 = local.enable_rds_count
  db_cluster_identifier = var.rds_cluster_name
  feature_name          = "s3Import"
  role_arn              = aws_iam_role.rds_s3[0].arn
}


/* resource "aws_iam_role" "rds_s3_export" {
  
  path                 = "/"
  name                 = "${var.namespace}-${var.stage}-${var.service}-rds-s3-export"
  max_session_duration = 3600
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

tags = merge(
    var.default_tags
  )
} */