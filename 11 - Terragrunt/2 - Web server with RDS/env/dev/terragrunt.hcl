include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//wordpress"
}

# DEV Exclusive Attributes
inputs = {
  database_password = "dev-PassWord4-user" # RDS password - Avoid for Production use case
  region            = "us-east-1"
  AZ1              = "us-east-1a" # EC2
  AZ2              = "us-east-1b" # RDS 
  AZ3              = "us-east-1c" # RDS replica
  VPC_cidr         = "10.0.0.0/16"
  subnet1_cidr     = "10.0.1.0/24" # Public Subnet for EC2
  subnet2_cidr     = "10.0.2.0/24" # Private Subnet for RDS
  subnet3_cidr     = "10.0.3.0/24" # Private subnet for RDS
  instance_type    = "t2.micro" 
  instance_class   = "db.t2.micro"
}