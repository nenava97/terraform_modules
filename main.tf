# configure aws provider
provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Create VPC
module "vpc" {
  source = "./vpc"
}

# Create Instances
module "ec2s" {
  source = "./ec2"
  priv_subnet_id           = module.vpc.priv_subnet_id
  priv_sg_id = module.vpc.priv_sg_id
  pub_subnet_id = module.vpc.pub_subnet_id
  pub_sg_id = module.vpc.pub_sg_id
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  }


output "web_instance_ip" {
  value = module.ec2s.web_ip
  }