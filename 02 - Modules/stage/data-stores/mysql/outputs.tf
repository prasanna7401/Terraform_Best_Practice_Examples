output "address" {
  value       = module.db_prod.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.db_prod.port
  description = "The port the database is listening on"
}
