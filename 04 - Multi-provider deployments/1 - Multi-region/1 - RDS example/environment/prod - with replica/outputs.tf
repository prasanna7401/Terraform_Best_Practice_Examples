output "mysql_primary_address" {
  value = module.mysql_primary.address
}

output "mysql_primary_port" {
  value = module.mysql_primary.port
}

output "mysql_primary_arn" {
  value = module.mysql_primary.arn
}

output "mysql_replica_address" {
  value = module.mysql_replica.address
}

output "mysql_replica_port" {
  value = module.mysql_replica.port
}

output "mysql_replica_arn" {
  value = module.mysql_replica.arn
} 
