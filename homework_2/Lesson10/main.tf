#......................................
#
# Provision highly available Web in any region default VPC
# Create:
#       - Security group for web server
#       - Launch configuration with Auto AMI lookup
#       - Auto Scaling Group using 2 Availability zones
#       - Classic Load balancer in 2 Availability zones
#
# Made by kattykarpova 27-09-2021
#.......................................

provider "aws" {
  region = "eu-central-1"
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

  tags = {
  Name = "Web server Security group"
  Owner = "Kateryna Karpova"
 }
}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_amazon_linux" {
  owners           = ["amazon"]  
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_launch_configuration" "web" {
  /*name          = "WebServer-Highly-Available-LC" */
  name_prefix   = "WebServer-Highly-Available-LC-"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"
  security_groups = [aws_security_group.web.id]
  user_data = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bar" {
  name                      = "ASG-${aws_launch_configuration.web.name}"  #имя будет подтягиваться из LC
  max_size                  = 2    #autoscaling group will be always holding 2 servers
  min_size                  = 2    
  min_elb_capacity          = 2    #LB tells that 2 servers are good for usage, health checks are good
  health_check_type         = "ELB"  #EC2 ASG will kill check servers that they work thaanks to system checks /or ELB-will make ping to our webservers, otherwise it will kill server
  launch_configuration      = aws_launch_configuration.web.name
  vpc_zone_identifier       = [aws_default_subnet.default_az1.id,aws_default_subnet.default_az2.id] #in which subnets can be servers launched
  load_balancers            = [aws_elb.web.name]

    dynamic "tag" {
        for_each = {
            Name = "Webserver-in-ASG"
            Owner = "Kateryna Karpova"
            TAGKEY = "TAGVALUE"
        }
        content {
            key = tag.key
            value = tag.value
            propagate_at_launch = true
        }
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"   #part of this will be our DNS name
  availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1]]
  security_groups = [aws_security_group.web.id]


  listener {
    lb_port           = 80   #incoming traffic to LB
    lb_protocol       = "http"
    instance_port     = 80  #will forward incoming trafic on instance from LB
    instance_protocol = "http"
  }

  health_check {    
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    Name = "WebServer-Higly-Available-ELB"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}