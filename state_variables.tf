variable "bucket" {
  type        = string
  description = "The name of the S3 bucket for Terraform state"
  validation {
    condition     = length(var.bucket) > 0
    error_message = "Bucket name must not be empty."
  }
}

variable "key" {
  type        = string
  description = "The key for the Terraform state file in the S3 bucket"
  validation {
    condition     = length(var.key) > 0
    error_message = "Key must not be empty."
  }
}

variable "region" {
  type        = string
  description = "The AWS region where the S3 bucket is located"
  validation {
    condition     = length(var.region) > 0
    error_message = "Region must not be empty."
  }
}

variable "dynamodb_table" {
  type        = string
  description = "The DynamoDB table for Terraform state locking"
  validation {
    condition     = length(var.dynamodb_table) > 0
    error_message = "DynamoDB table name must not be empty."
  }
}
