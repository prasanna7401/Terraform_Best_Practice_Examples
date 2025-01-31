include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../modules//wordpress"
}

# PROD Exclusive Attributes
inputs = {
  database_password = "prod-PassWord4-user" # RDS password - Avoid for Production use case
  region            = "us-east-2"
  AZ1             = "us-east-2a" # EC2
  AZ2             = "us-east-2b" # RDS 
  AZ3             = "us-east-2c" # RDS replica
  VPC_cidr        = "10.10.0.0/16" 
  subnet1_cidr    = "10.10.1.0/24" # Public Subnet for EC2
  subnet2_cidr    = "10.10.2.0/24" # Private Subnet for RDS
  subnet3_cidr    = "10.10.3.0/24" # Private Subnet for RDS
  instance_type   = "t2.small"  
  instance_class  = "db.t2.small"
}
