#......................................
#
#Find latest AMI id of:
#      - Ubuntu 20.04
#
#.......................................


provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_webserver_ubuntu" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"
}


data "aws_ami" "latest_ubuntu" {
  owners           = ["099720109477"]  #find it taking ami in instances and finding this ami in th aws section
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

output "latest-ubuntu-ami-id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest-ubuntu-ami-name" {
  value = data.aws_ami.latest_ubuntu.name
}