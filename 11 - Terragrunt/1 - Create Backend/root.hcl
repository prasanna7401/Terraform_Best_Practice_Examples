# If you already have a backend setup, use generate block
# generate "backend" {

#   path = "backend.tf"
#   if_exists = "overwrite_terragrunt"

#   contents = <<EOF
#     terraform {
#     backend "s3" {
#         bucket = "prasanna-tfstate-example"
#         key = "${path_relative_to_include()}/terraform.tfstate"
#         region = "us-east-2"
#         encrypt = true
#         dynamodb_table = "prasanna-tfstate-lock"
#       }
#     }
#     EOF
# }

# If you don't have a backend setup, use remote_state block

remote_state {

  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = "prasanna-tfstate-example"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "prasanna-tfstate-lock"
  }
}
