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
  availability_zone = "eu-central-1"
  #vpc_security_group_ids = ["sg-06b113f865b048168"]  #security group attached to this instance if security group is known
  vpc_security_group_ids = ["${aws_security_group.my_webserver.id}"] #refres to the security group which will be craeted below
  user_data =<<-EOF
#!/bin/bash
sudo yum install httpd -y 
sudo systemctl start httpd
sudo systemctl enable httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform using External Script!"  >  /var/www/html/index.html
echo "<br><font color="blue">Hello WebAcademy!!" >> /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF

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
      description      = "HTTPS"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]  
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
