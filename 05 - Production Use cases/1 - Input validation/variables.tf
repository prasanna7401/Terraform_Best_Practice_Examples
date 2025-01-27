variable "instance_type" {
  description = "The type of instance to launch"
  type = string
  
  # HARD CODED Validation
  # validation {
  #   condition = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
  #   error_message = "The instance type must be either t2.micro, t2.small, or t2.medium"
  # }

}