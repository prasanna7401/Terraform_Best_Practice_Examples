output "address" {
    value = aws_db_instance.main.address
    description = "Address of the RDS instance"
}

output "port" {
    value = aws_db_instance.main.port
    description = "Port of the RDS instance"
}

output "arn" {
    value = aws_db_instance.main.arn
    description = "ARN of the RDS instance"
}