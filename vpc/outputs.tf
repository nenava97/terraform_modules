output "priv_subnet_id" {
    value = aws_subnet.priv_subnet.id
}

output "pub_subnet_id" {
    value = aws_subnet.pub_subnet.id
}

output "pub_sg_id" {
  value = aws_security_group.web_ssh.id
}

output "priv_sg_id" {
  value = aws_security_group.app_ssh.id
}