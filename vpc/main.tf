##################### VPC #################################
# Create VPC
resource "aws_vpc" "new_vpc" {
  cidr_block              = "172.19.0.0/16" #defines the entire IP range for the VPC.
  instance_tenancy        = "default"
  #enable_dns_hostnames    = true

  tags      = {
    Name    = "custom_vpc"
  }
}

##################### PUBLIC ROUTE TABLE #################################
# Create route table
resource "aws_route_table" "public_rt" {
  #provider = aws.useast1
  vpc_id   = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "pub_rt"
  }
}

##################### PUBLIC SUBNET #################################
# Create a subnet within the VPC
resource "aws_subnet" "pub_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "172.19.0.0/17" #a subset of the VPC’s CIDR block.
  map_public_ip_on_launch = true #determines if public!

  tags      = {
    Name    = "pub_subnet"
  }
}

##################### PUBLIC ROUTE TABLE ASSOCIATION #################################
# Associate route table with the subnet
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

##################### WEB SECURITY GROUP #################################
resource "aws_security_group" "web_ssh" {  #A security group is attached to a VPC, and it is used to control the inbound and outbound traffic for resources within that VPC.
  name        = "web_ssh"                           
  description = "open ssh traffic"                      
  vpc_id = aws_vpc.new_vpc.id #Need from VPC module

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0                                     
    to_port     = 0
    protocol    = "-1"                                
    cidr_blocks = ["0.0.0.0/0"]                        
  }

  # Tags for the security group
  tags = {
    "Terraform" : "true"                                
  }
}
############### Elastic IP #############################3
resource "aws_eip" "nat_eip" {
  domain = "vpc" # Specify that this EIP is for VPC usage
}
##################### NAT GATEWAY ###################################
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet.id

  tags = {
    Name = "nat_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.tf_igw]
}
##################### PRIVATE ROUTE TABLE #################################
# Create route table
resource "aws_route_table" "private_rt" {
  #provider = aws.useast1
  vpc_id   = aws_vpc.new_vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "priv_rt"
  }
}

##################### PRIVATE SUBNET #################################
# Create a subnet within the VPC
resource "aws_subnet" "priv_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = "172.19.128.0/17" #a subset of the VPC’s CIDR block.
  #map_public_ip_on_launch = true #determines if public!

  tags      = {
    Name    = "priv_subnet"
  }
}

##################### PRIVATE ROUTE TABLE ASSOCIATION #################################
# Associate route table with the subnet
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

##################### APP SECURITY GROUP #################################
resource "aws_security_group" "app_ssh" {  #A security group is attached to a VPC, and it is used to control the inbound and outbound traffic for resources within that VPC.
  name        = "app_ssh"                            
  description = "open ssh traffic"                      
  vpc_id = aws_vpc.new_vpc.id #Need from VPC module

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0                                     
    to_port     = 0
    protocol    = "-1"                                
    cidr_blocks = ["0.0.0.0/0"]                        
  }

  # Tags for the security group
  tags = {
    "Terraform" : "true"                                
  }
}

##################### INTERNET GATEWAY #################################
#Create IGW
resource "aws_internet_gateway" "tf_igw" {
  vpc_id   = aws_vpc.new_vpc.id

  tags = {
    Name = "tf_igw"
  }
}