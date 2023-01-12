# S3 triggers Lambda module

Simple module that configures a bucket to trigger a lambda function. Creates the lambda from a source directory with the appropiate permissions to launch from S3.

Whilst this has been built for internal use it is publily available. 

## Lambdas
Only zip lambdas are supported, layers are supported. 

## Zip/Version Management
It will automatically create a new zip file when the random_keeper_id is changed. This can be set via a filemd5 has function to automatically update. See example for how to create an md5 based on files.


## Examples
See the examples folder.


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.rds_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.lambda_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.rds_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_vpc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_rds_cluster_role_association.s3import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_role_association) | resource |
| [aws_s3_bucket_notification.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [random_uuid.default](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [archive_file.default](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.lambda_vpc_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_filter_prefix"></a> [bucket\_filter\_prefix](#input\_bucket\_filter\_prefix) | The bucket prefix/directory that causes the lambda to fire. Default is blank (root) | `string` | `""` | no |
| <a name="input_bucket_filter_suffix"></a> [bucket\_filter\_suffix](#input\_bucket\_filter\_suffix) | The bucket file that causes the lambda to fire | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | s3 bucket that triggers the event | `string` | `null` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default resource tags | `map(string)` | <pre>{<br>  "Terraform": "true"<br>}</pre> | no |
| <a name="input_enable_bucket_trigger"></a> [enable\_bucket\_trigger](#input\_enable\_bucket\_trigger) | If enabled triggers the lambda when an object is created is the specified bucket | `bool` | `false` | no |
| <a name="input_enable_rds_s3import"></a> [enable\_rds\_s3import](#input\_enable\_rds\_s3import) | Whether to enable s3 import to the RDS. if bucket\_name is set access to the bucket will be given to rds. RDS will still need to have the extensions added. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variables to pass to the lambda | <pre>object({<br>    variables = map(string)<br>  })</pre> | `null` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | The name of the function e.g. incoming\_billing | `string` | n/a | yes |
| <a name="input_handler_filename"></a> [handler\_filename](#input\_handler\_filename) | File and handler that the lambda runs, can be any supported language | `string` | `"index.js"` | no |
| <a name="input_lambda_src_path"></a> [lambda\_src\_path](#input\_lambda\_src\_path) | Where are the files to be zipped? Be care of relative module paths | `string` | `"../src/"` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | Lambda layer ARNs to attach | `list(string)` | `[]` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Cloudwatch log retention days | `number` | `14` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Lambda memory to assign | `number` | `128` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Usually the company name or some other broad reference | `string` | n/a | yes |
| <a name="input_random_keeper_id"></a> [random\_keeper\_id](#input\_random\_keeper\_id) | used to generate keepers for the random\_uuid resource. can be md5 of filesets that change when the the lambda source is changed | `string` | n/a | yes |
| <a name="input_rds_cluster_name"></a> [rds\_cluster\_name](#input\_rds\_cluster\_name) | rds cluster name to enable s3 import. | `string` | `""` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | `"python3.9"` | no |
| <a name="input_service"></a> [service](#input\_service) | The application/service this is used with/for | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The environment/stage e.g. dev, test, or  prod | `string` | n/a | yes |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Required when connecting to RDS or other network resources | <pre>object({<br>    security_group_ids = list(string)<br>    subnet_ids         = list(string)<br>  })</pre> | `null` | no |
| <a name="input_zip_exclude_list"></a> [zip\_exclude\_list](#input\_zip\_exclude\_list) | List of files to exclude from the lambda\_src\_path directory | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | n/a |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | n/a |
<!-- END_TF_DOCS -->