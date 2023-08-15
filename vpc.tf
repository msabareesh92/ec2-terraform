resource "aws_vpc" "dev-vpc" {
    cidr_block = "192.168.0.0/16"
    tags = {
      "Name" = "DEV-VPC"
    }
  
}
resource "aws_subnet" "dev-public-1" {
    depends_on = [
      aws_vpc.dev-vpc
    ]
    cidr_block = "192.168.0.0/17"
    availability_zone = "us-east-1a"
    tags = {
      "name" = "dev-publicsubnet"
    }
    vpc_id = aws_vpc.dev-vpc.id
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "dev-private-1" {
    depends_on = [
      aws_vpc.dev-vpc
    ]
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "192.168.128.0/17"
    availability_zone = "us-east-1b"
    tags = {
      "name" = "dev-privatesubnet"
    }
    map_public_ip_on_launch = false
  
}

resource "aws_internet_gateway" "vpc-dev-ig" {
    vpc_id = aws_vpc.dev-vpc.id
  
}

resource "aws_route_table" "vpc-dev-public-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
      "Name" = "dev-vpc-public-rt"
    }
  
}
resource "aws_route" "vpc-dev-public-route" {
    route_table_id = aws_route_table.vpc-dev-public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-dev-ig.id
  
}
resource "aws_route_table_association" "vpc-dev-public-assocation" {
    route_table_id = aws_route_table.vpc-dev-public-rt.id
    subnet_id = aws_subnet.dev-public-1.id
  

}

resource "aws_eip" "nateip" {
    depends_on = [
      aws_route_table_association.vpc-dev-public-assocation
    ]
    vpc = true
  
}

resource "aws_nat_gateway" "mynat" {
    depends_on = [
      aws_eip.nateip
    ]
    allocation_id = aws_eip.nateip.id
    subnet_id = aws_subnet.dev-private-1.id
    tags = {
      "Name" = "DEV-NAT"
    }



  
}

resource "aws_route_table" "vpc-dev-private-rt" {
    vpc_id = aws_vpc.dev-vpc.id
    tags = {
      "Name" = "dev-vpc-private-rt"
    }


} 

resource "aws_route" "vpc-dev-private-route" {
    route_table_id = aws_route_table.vpc-dev-private-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynat.id
  
}
resource "aws_route_table_association" "vpc-dev-private-assocation" {
    route_table_id = aws_route_table.vpc-dev-private-rt.id
    subnet_id = aws_subnet.dev-private-1.id
  

}
