variable "stage" {
  default = "development"
}

variable "namespace" {
  default = "berkeley"
}
variable "service" {
  default = "s3lambda"
}

variable "default_tags" {
  type        = map(string)
  description = "Default resource tags"
  default = {
    Environment = "Development"
    Terraform   = "true"
  }
}

variable "log_retention_days" {
  type    = number
  default = 14

}


