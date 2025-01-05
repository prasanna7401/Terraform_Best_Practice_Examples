variable "server_port" {
  description = "The port the web server will listen on for HTTP requests"
  type        = number
  default     = 80
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    deployment = "terraform-managed"
  }
}