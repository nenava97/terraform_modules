# Define what input variables can be passed into the config file
variable aws_access_key {
    type = string
    sensitive = true
} 
variable aws_secret_key {
    type = string
    sensitive = true
}
variable region {
    type = string
    default = "us-east-1"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami" {}
variable "key_name" {}