output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_type" {
  description = "Instance type of the EC2 instance"
  value       = aws_instance.this.instance_type
}

output "instance_tags" {
  description = "Tags applied to the EC2 instance"
  value       = aws_instance.this.tags
}
