data "aws_caller_identity" "prod" {
  provider = aws.prod
}

data "aws_caller_identity" "dev" {
  provider = aws.dev
}