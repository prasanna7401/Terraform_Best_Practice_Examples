# outputs - public IP of the ELB

output "elb_dns_name" {
  value       = aws_lb.web-server-elb.dns_name
  description = "DNS name of the Load Balancer"
}