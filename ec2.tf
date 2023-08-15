# Resource-8: Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = "ami-0fa1de1d60de6a97e" # Amazon Linux
  instance_type          = "t2.micro"
  key_name               = "newsaccount"
  subnet_id              = aws_subnet.dev-public-1.id
  vpc_security_group_ids = [aws_security_group.myappnsg.id]
  #user_data = file("apache-install.sh")
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to Terraform !</h1>" > /var/www/html/index.html
    EOF
  tags = {
    "Name" = "webserver"
  }    
}