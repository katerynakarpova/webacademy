# ...........................................................
# My Terraform
#
# Buld webserver during Bootstrap
#
# Made by Kateryna Karpova
# ...........................................................


provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "my_webserver" {
  ami = "ami-07df274a488ca9195"    #Amazon Linux AMI
  instance_type = "t3.micro"
  /*availability_zone = "eu-central-1a"
  vpc_security_group_ids = ["sg-06b113f865b048168"]  #security group attached to this instance if security group is known */
  vpc_security_group_ids = ["${aws_security_group.my_webserver.id}"] #refres to the security group which will be craeted below
  user_data = file("user_data.sh")
  key_name = aws_key_pair.deployer.key_name


tags = {
  Name = "Web server built by Terraform"
  Owner = "Kateryna Karpova"
 }
}

resource "aws_security_group" "my_webserver" {
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

  tags = {
  Name = "Web server Security group"
  Owner = "Kateryna Karpova"
 }
}


resource "aws_key_pair" "deployer" {
  key_name   = "webserver"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDICnUcqMvaeKPfwCVx18TOlj2Io2OMhn1gGh0NB24EN6lkl5/WC+5y0I9B/OBLRSZH3p4ZzAyGDUV1G62TQc9KIrkxW99r974RLODjPR2zKil4J3Mu8hkTbH4kShXqnBzOr4w+jVn3+JCUNwIppzMOpjwUSKNqI6I9a2I4keBhzfNq3KByO6/YejepvwI/wyHzochl896m/joDfGADf/TZmEh9uzOD4Q/KNOKdGPTVEvH8bUOPWEoQX6/O6wwWNq4OXDkMZZ4uif/V8BZUi5rvB+E9lX6mLK2GaXbfIA5/o1EWPhkHuJts3NappSH5kWub/CSwt9kv39PJZM5vDmyxnEAvEK5KkcgKy21rHCTxqq55qZhxabAKZNP7JrN5D/59JJrgsyw/orhraLy7EGGqqyMhWllX5BW9AbwgSKP0EA6cnrJIjF2QO2bNIVtr4wdqkgima8ST4On3NPB83jCzGHIDb9fqMtCeXWIualnRZFa2l0BS7QzBB7Fj2YTw4kU= katty@MBP-Kateryna"
}

/*add public key here generated locally on mac ‘ssh-keygen -t rsa’
‘ssh -i key ec2-user@ec2-3-69-25-35.eu-central-1.compute.amazonaws.com’ use locally on mac to ssh to VM , where key is the location of the file (if you are in the folder with key just leave as it is)*/