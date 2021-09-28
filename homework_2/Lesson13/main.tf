provider "aws" {
region = "eu-central-1"
}


data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

resource "aws_eip" "static_ip" {
  tags = {
    Name = "static_ip"
    Owner = var.owner
    Project = local.full_project_name
    proj_owner = local.project_owner
    city = local.city
    region_azs = local.az_list
    location = local.location
  }
}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner = "${var.owner} owner of ${var.project_name}"
}

locals {
  country = "Ukraine"
  city = "Kiev"
  az_list = join(",",data.aws_availability_zones.available.names)
  region = data.aws_region.current.description
  location = "In ${local.region} there are ${local.az_list}"
}