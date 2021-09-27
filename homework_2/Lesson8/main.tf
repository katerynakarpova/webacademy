provider "aws" {}
#eu-central-1
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "info" {}
data "aws_vpcs" "mu_VPCs" {}
data "aws_vpc" "selected" {  #filter vpc which is called prod
  tags = {
    "Name" = "prod"
  }
}


resource "aws_subnet" "subnet_prod_1" {
  vpc_id = data.aws_vpc.selected.id
  availability_zone = data.aws_availability_zones.available.names[0]      
  cidr_block = ["10.10.1.0/24"]
  tags = {
    "Name" = "Subnet1 in ${data.aws_availability_zones.available.names[0]}"
    Account = "Subnet1 in ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.info.description
  }
}

resource "aws_subnet" "subnet_prod_2" {
  vpc_id = data.aws_vpc.selected.id
  availability_zone = data.aws_availability_zones.available.names[1]
  cidr_block = ["10.10.2.0/24"]
  tags = {
    "Name" = "Subnet1 in ${data.aws_availability_zones.available.names[1]}"
    Account = "Subnet1 in ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.info.description
  }
}


output "cidr_vpc_id" {                                  #cidr of vpc
  value = data.aws_vpc.selected.cidr_block
}

output "prod_vpc_id" {
  value = data.aws_vpc.selected.id                     #id of vpc
}
output "prod_vpc_cidr_block" {                         
  value = data.aws_vpc.selected.cidr_block
}
output "my_VPCs" {                                      #list of all craeted vpcs for this account
  value = data.aws_vpcs.mu_VPCs.ids
}
output "zones" {
  value = data.aws_availability_zones.available.names   #list of available zones 
}
output "account_id" {                                   #aws account id
  value = data.aws_caller_identity.current.account_id
}
output "description_aws_region" {                       #eg Frankfurt
  value = data.aws_region.info.description
}
output "data_aws_region" {                              #eg eu-cantral-1
  value = data.aws_region.info.name
  }
