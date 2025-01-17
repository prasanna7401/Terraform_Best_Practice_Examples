# ----------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}

# --------------------------------------------------
# OPTIONAL PARAMETERS
# --------------------------------------------------

variable "db_type" {
  description = "The type of database to use"
  type        = string
  default     = "mysql"
}

