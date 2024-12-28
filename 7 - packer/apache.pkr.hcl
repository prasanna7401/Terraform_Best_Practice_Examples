packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_id" {
  type    = string
  default = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
}

locals {
  app_name = "httpd"
}

# creating EBS backed AMI
source "amazon-ebs" "httpd" {
  ami_name      = "pva-corp_${local.app_name}" # name of the AMI
  instance_type = "t2.micro"
  source_ami    = var.ami_id
  ssh_username = "ec2-user"
  region       = "us-east-1"
  tags = {
    Name       = local.app_name
    Deployment = "terraform-cloud"
  }
}

build {
  sources = ["source.amazon-ebs.httpd"]
  provisioner "shell" {
    //script = "scripts/install_httpd.sh"
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}