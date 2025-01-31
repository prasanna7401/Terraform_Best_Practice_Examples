output "IP" {
  value = aws_eip.eip.public_ip
}

output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

output "INFO" {
  value = "Site URL: http://${aws_eip.eip.public_ip} "
}