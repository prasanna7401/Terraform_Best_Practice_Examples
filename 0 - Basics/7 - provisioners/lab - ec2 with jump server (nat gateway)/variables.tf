variable "tags" {
  type = map(string)
  default = {
    Deployment = "terraform-managed"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vm-user" {
  default = "ubuntu"
}

