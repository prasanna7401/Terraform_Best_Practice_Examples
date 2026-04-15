output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.public[*].id
}

output "route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "igw_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}
