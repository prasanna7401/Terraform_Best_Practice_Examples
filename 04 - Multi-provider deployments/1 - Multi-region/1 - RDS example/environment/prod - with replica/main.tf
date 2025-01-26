module "mysql_primary" {
  source = "../../modules/rds"
  providers = {
    aws = aws.primary
  }
db_name = var.db_name
username = var.username
password = var.password
backup_retention_period = 1 # Must be set > 0 to set up replication
}

module "mysql_replica" {
  source = "../../modules/rds"
  providers = {
    aws = aws.secondary
  }
  replicate_source_db = module.mysql_primary.arn
}