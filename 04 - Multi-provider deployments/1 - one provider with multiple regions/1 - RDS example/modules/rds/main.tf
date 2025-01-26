resource "aws_db_instance" "main" {
  identifier_prefix = "pva-" # prefix for the RDS instance name
  allocated_storage = 10
  instance_class = "db.t3.micro" # Minimum requirement to support replication
  skip_final_snapshot = true # don't create a final snapshot when the instance is deleted

  backup_retention_period = var.backup_retention_period
  replicate_source_db = var.replicate_source_db # if set, this RDS instance will be a read replica of the specified source DB

  # The following attributes are set if this is not a read replica
  engine = var.replicate_source_db == null ? "mysql" : null
  db_name = var.replicate_source_db == null ? var.db_name : null
  username = var.replicate_source_db == null ? var.username : null
  password = var.replicate_source_db == null ? var.password : null
}