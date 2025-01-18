# declare existing VPC for reference - DATA
data "aws_vpc" "main" {
    default = true
}

# data "aws_vpc" "my_vpc" {
#     filter {
#         name   = "tag:Name"
#         values = ["myvpc-*"]
#     }
# }