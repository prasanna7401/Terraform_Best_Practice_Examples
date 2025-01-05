output "vm-info" {
	value = <<-EOT
  VM Username: ${var.vm-user}
  Public VM IP: ${aws_instance.my-ec2-pub.public_ip}
  Private VM IP: ${aws_instance.my-ec2-priv.private_ip}
  NAT Gateway IP: ${aws_nat_gateway.nat-gw.public_ip}
  EOT
}