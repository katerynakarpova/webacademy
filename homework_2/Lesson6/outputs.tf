output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip" {
  value = aws_eip.my_statuc_ip.public_ip
}

output "sg_id" {
  value = aws_security_group.my_webserver.id
}

output "arn" {
  value = aws_security_group.my_webserver.arn
  description = "this is security group arn"
}