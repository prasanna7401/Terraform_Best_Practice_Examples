variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,31}$", var.alb_name))
    error_message = "ALB name must start with a letter, contain only alphanumeric characters and hyphens, and be at most 32 characters."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "ALB requires at least 2 subnets in different availability zones."
  }
}

variable "vpc_id" {
  description = "VPC ID for the ALB security group"
  type        = string
}
