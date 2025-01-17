resource "aws_db_instance" "example" {
  identifier_prefix   = "prasanna-tf-example" # Adds a prefix to the identifier of the DB instance
  engine              = var.db_type
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}