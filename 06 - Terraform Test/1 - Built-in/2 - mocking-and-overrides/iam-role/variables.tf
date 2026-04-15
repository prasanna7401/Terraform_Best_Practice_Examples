variable "role_name" {
  description = "Name of the IAM role"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_+=,.@-]{0,63}$", var.role_name))
    error_message = "Role name must start with a letter and contain only alphanumeric characters, plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-). Max 64 characters."
  }
}

variable "policy_arn" {
  description = "ARN of the IAM policy to attach"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.policy_arn))
    error_message = "Policy ARN must be a valid IAM policy ARN."
  }
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (1-12 hours)"
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "Max session duration must be between 3600 (1 hour) and 43200 (12 hours)."
  }
}
