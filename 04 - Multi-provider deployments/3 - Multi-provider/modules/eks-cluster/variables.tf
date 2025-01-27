variable "name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "instance_types" {
  description = "Instance type for the worker nodes"
  type        = list(string)
}
