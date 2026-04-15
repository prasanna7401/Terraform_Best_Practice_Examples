variable "db_name" {
  description = "Name/identifier for the RDS instance"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,62}$", var.db_name))
    error_message = "DB name must start with a lowercase letter, contain only lowercase alphanumeric characters and hyphens, and be 3-63 characters."
  }
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string

  validation {
    condition     = can(regex("^db\\.", var.instance_class))
    error_message = "Instance class must start with 'db.' prefix."
  }
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 1000
    error_message = "Allocated storage must be between 20 and 1000 GB."
  }
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"

  validation {
    condition     = can(regex("^[5-8]\\.", var.engine_version))
    error_message = "Engine version must be a valid MySQL version (5.x or 8.x)."
  }
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}
