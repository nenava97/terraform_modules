resource "aws_instance" "web_server" {
  ami               = var.ami              
  instance_type     = var.instance_type             
  subnet_id = var.pub_subnet_id #Need from VPC module
  vpc_security_group_ids = [var.pub_sg_id]
  
  key_name          = var.key_name                
  
  tags = {
    "Name" : "web_server"
    "Terraform" : "true"         
  }
}

resource "aws_instance" "app_server" {
  ami               = var.ami              
  instance_type     = var.instance_type             
  subnet_id = var.priv_subnet_id #Need from VPC module
  vpc_security_group_ids = [var.priv_sg_id]
  
  key_name          = var.key_name                
  
  tags = {
    "Name" : "app_server"
    "Terraform" : "true"         
  }
}

