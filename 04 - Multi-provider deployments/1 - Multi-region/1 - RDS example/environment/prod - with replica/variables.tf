variable "db_name" {
  description = "The name of the database"
  default     = "mydb"
}

variable "username" {
  description = "The username for the database"
  sensitive = true
}

variable "password" {
  description = "The password for the database"
  sensitive  = true
}