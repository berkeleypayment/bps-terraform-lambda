variable "stage" {
  type        = string
  description = "The environment/stage e.g. dev, test, or  prod"
}

variable "namespace" {
  type        = string
  description = "Usually the company name or some other broad reference"
}
variable "service" {
  type        = string
  description = "The application/service this is used with/for"
}
variable "function_name" {
  type        = string
  description = "The name of the function e.g. incoming_billing"
}

variable "handler_filename" {
  type        = string
  description = "File and handler that the lambda runs, can be any supported language "
  default     = "index.js"
}

variable "default_tags" {
  type        = map(string)
  description = "Default resource tags"
  default = {
    Terraform = "true"
  }
}

variable "log_retention_days" {
  type        = number
  default     = 14
  description = "Cloudwatch log retention days"
}

variable "environment" {
    type = object({
    variables = map(string)
  })
  default     = null
  description = "Environment variables to pass to the lambda"

}

variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  description = "Required when connecting to RDS or other network resources"
  default     = null
}
variable "lambda_src_path" {
  default     = "../src/"
  description = "Where are the files to be zipped? Be care of relative module paths"
}

variable "random_keeper_id" {
  type        = string
  description = "used to generate keepers for the random_uuid resource. can be md5 of filesets that change when the the lambda source is changed "

}

variable "zip_exclude_list" {
  type        = list(string)
  default     = []
  description = "List of files to exclude from the lambda_src_path directory"
}


variable "layers" {
  type        = list(string)
  description = "Lambda layer ARNs to attach"
  default     = []
}

variable "memory_size" {
  type        = number
  description = "Lambda memory to assign"
  default     = 128
}
variable "runtime" {
  default = "python3.9"
}

variable "bucket_filter_prefix" {
  type        = string
  description = "The bucket prefix/directory that causes the lambda to fire. Default is blank (root)"
  default     = ""
}

variable "bucket_filter_suffix" {
  type        = string
  description = "The bucket file that causes the lambda to fire"

}

variable "enable_rds_s3import" {
  type        = bool
  default     = false
  description = "Whether to enable s3 import to the RDS. if bucket_name is set access to the bucket will be given to rds. RDS will still need to have the extensions added. "
}

variable "rds_cluster_name" {
  type        = string
  default     = ""
  description = "rds cluster name to enable s3 import. "
}

variable "bucket_name" {
  type        = string
  default     = null
  description = "s3 bucket that triggers the event"
}


variable "enable_bucket_trigger" {
  type        = bool
  default     = false
  description = "If enabled triggers the lambda when an object is created is the specified bucket"
}