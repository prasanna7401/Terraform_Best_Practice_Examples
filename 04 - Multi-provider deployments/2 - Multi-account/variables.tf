variable "dev_role_arn" {
  description = "The ARN of the role to assume in the dev account"
  type = string
  default = "arn:aws:iam::218323737322:role/OrganizationAccountAccessRole"
}