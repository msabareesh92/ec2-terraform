resource "aws_security_group" "myappnsg" {
    vpc_id = aws_vpc.dev-vpc.id
    description="Sg for webserver"
    name = "DEV-vpc-http-ssh"

    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow port 22"
      from_port = 22
      to_port =22
      protocol = "tcp"

    }
    ingress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow port 80"
      from_port = 80
      to_port =80
      protocol = "tcp"

    }     

    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "allow all"
      from_port = 0
      to_port =0
      protocol = "-1"
    

    }
  
}