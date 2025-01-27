variable "name" {
  description = "Name of the resource"
  type        = string
}

variable "image" {
  description = "Docker image to deploy"
  type        = string
}

variable "container_port" {
  description = "Port to expose in the container"
}

variable "local_port" {
  description = "Port to expose on the local machine"
}

variable "replicas" {
  description = "Number of replicas to deploy"
  type        = number
}

variable "env_vars" {
  description = "Environment variables to set in the container"
  type        = map(string)
  default     = {}
}