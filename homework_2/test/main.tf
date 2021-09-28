

provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners = ["amazon"]
  most_recent = true
  filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_security_group" "web" {
  name        = "webserver security group"
  description = "My first security group"


 ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },

    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
  },

      {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["176.36.145.35/32"]  
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false      
  }
]
  

  egress = [
    {
      description      = "null"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
    
  ]

  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Web server Security group"})


  /*tags = {
  Name = "Web server Security group"
  Owner = "Kateryna Karpova"
 }
 */

}

resource "aws_instance" "server" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  monitoring = var.enable_detailed_monitoring
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server"})

   /* tags = {
    Name  = "Server"
    Owner = "Kateryna Karpova"
    Project = "Wakanda"
    Region = var.region
  }
  */

}

resource "aws_eip" "static_ip" {
  instance = aws_instance.server.id
  //tags = var.common_tags
  tags = merge(var.common_tags, {Name = "${var.common_tags["Environment"]} Server IP"})

  /*tags = {
    Name  = "Server IP"
    Owner = "Kateryna Karpova"
    Project = "Wakanda"
  }*/

}