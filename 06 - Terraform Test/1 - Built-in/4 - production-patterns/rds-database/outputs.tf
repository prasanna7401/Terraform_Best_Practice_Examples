output "endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.this.db_name
}

output "instance_class" {
  description = "Instance class of the RDS instance"
  value       = aws_db_instance.this.instance_class
}
