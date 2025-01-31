# Create S3 bucket for remote backend. Use generate block if remote backend already exists
remote_state {
  backend = "s3"
  config = {
    bucket         = "prasanna7401-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

# Common Attributes for all environments
inputs = {
  ami_id        = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  database_name = "myuserdb"
  database_user = "dbadmin" 
  IsUbuntu          = true e
  PUBLIC_KEY_PATH  = "./mykey-pair.pub" # Create locally using ssh-keygen
  PRIV_KEY_PATH    = "./mykey-pair"
  root_volume_size = 22
}
