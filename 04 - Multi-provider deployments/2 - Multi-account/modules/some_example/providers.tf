terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "5.0"
        configuration_aliases = [ aws.prod, aws.dev ]
        }
    }
}

# The below is commented out since the provider configurations are passed in via
# root module using `configuration_aliases`

# provider "aws" {
#     region = "us-east-1" # N. Virginia
#     alias = "prod"
# }

# provider "aws" {
#     region = "us-west-2" # Oregon
#     alias = "dev"

#     assume_role {
#         role_arn = "arn:aws:iam::<YOUR_ACCOUNT_ID>:role/<YOUR_CROSS_ACCOUNT_ROLE_NAME>" # Role in the dev account
#     }
# }