output "prod_account_id" {
  value = data.aws_caller_identity.prod.account_id
}

output "dev_account_id" {
  value = data.aws_caller_identity.dev.account_id
}