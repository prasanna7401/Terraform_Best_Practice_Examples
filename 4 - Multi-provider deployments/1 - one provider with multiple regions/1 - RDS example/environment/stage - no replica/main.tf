module "mysql" {
  source = "../../modules/rds"
db_name = var.db_name
username = var.username
password = var.password
}