provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "command" {
  provisioner "local-exec" {
    command = "echo Terraform START: $(date) >> log.txt"
    interpreter = ["/bin/zsh", "-c"]
  }
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }

  depends_on = [
    null_resource.command
  ]
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
  command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "X"
      NAME2 = "XX"
      NAME3 = "XXX"
     }
  }
}

resource "aws_instance" "myserver" {
  ami = "ami-07df274a488ca9195"    
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command = "echo Terraform END: $(date) >> log.txt"
    interpreter = ["/bin/zsh", "-c"]
  }
  depends_on = [null_resource.command, null_resource.command1, null_resource.command2, null_resource.command3, aws_instance.myserver]
  
}