#### Create an EC2 Instance - Public Subnet

resource "aws_instance" "my-ec2-pub" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  availability_zone           = aws_subnet.public.availability_zone
  key_name                    = aws_key_pair.ec2-kp.key_name
  vpc_security_group_ids      = [aws_security_group.pub_sg.id]

  tags = var.tags

  # Connect to Public EC2 to perform provisioning - via SSH using local private key
  connection {
    user        = var.vm-user # ubuntu user
    private_key = file("my-ec2-kp") # path to local private key
    host        = self.public_ip
  }

  # Import Private Key to access Private EC2
  provisioner "file" {
    source      = "my-ec2-kp"         # name of the private key
    destination = "/home/${var.vm-user}/my-ec2-kp" # save in public ec2 home directory
  }
  
  provisioner "remote-exec" {
    inline = [ "chmod 600 my-ec2-kp" ] # change permission of the pvt key stored in public ec2
  }
}

# Create an EC2 Instance - Private Subnet
resource "aws_instance" "my-ec2-priv" {
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.private.id
  availability_zone           = aws_subnet.private.availability_zone
  key_name                    = aws_key_pair.ec2-kp.key_name
  vpc_security_group_ids      = [aws_security_group.priv_sg.id]

  tags = var.tags
}