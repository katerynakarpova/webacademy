variable "region" {    #if it's empty=will need to write it after terraform apply
  description = "Please Enter AWS Region to deploy server"
  type = string
  default = "eu-central-1"
}

variable "instance_type" {
  description = "Enter instance type"
  type = string
  default = "t3.micro"
}

variable "enable_detailed_monitoring" {
  type = bool    #checking on correct value
  default = "false"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map
  default = {
    Owner = "Kateryna Karpova"
    Project = "Wakanda"
    ConstCenter = "112345"
    Environment = "development"
  }
}