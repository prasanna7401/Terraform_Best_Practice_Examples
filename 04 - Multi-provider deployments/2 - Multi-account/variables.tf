variable "dev_role_arn" {
  description = "The ARN of the role to assume in the dev account"
  type = string
  default = "arn:aws:iam::<YOUR_ACCOUNT_ID>:role/<YOUR_CROSS_ACCOUNT_ROLE>"
}