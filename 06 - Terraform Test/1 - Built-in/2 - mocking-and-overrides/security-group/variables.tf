variable "sg_name" {
  description = "Name of the security group"
  type        = string

  validation {
    condition     = length(var.sg_name) >= 3
    error_message = "Security group name must be at least 3 characters."
  }
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}

variable "allowed_cidr_block" {
  description = "CIDR block allowed for ingress"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.allowed_cidr_block, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "ingress_port" {
  description = "Port to allow for ingress traffic"
  type        = number
  default     = 443

  validation {
    condition     = var.ingress_port > 0 && var.ingress_port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}
