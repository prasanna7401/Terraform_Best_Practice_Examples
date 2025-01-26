variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "The source DB to replicate"
  type        = string
  default     = null
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default = null
}

variable "username" {
  description = "The username for the database"
  type        = string
  sensitive = true
  default = null
}

variable "password" {
  description = "The password for the database"
  type        = string
  sensitive = true
  default = null
}