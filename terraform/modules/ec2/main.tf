resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = "t3.small"
  subnet_id     = var.subnet_id

  tags = {
    Name = "devops-ec2"
  }
}