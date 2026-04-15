variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string

  validation {
    condition     = length(var.bucket_prefix) >= 3 && length(var.bucket_prefix) <= 37
    error_message = "Bucket prefix must be between 3 and 37 characters."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "tags" {
  description = "Additional tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
