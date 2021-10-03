provider "aws" {
  region = "eu-central-1"
  version = "~> 2.64"
}
 #generating pass
resource "random_string" "rds_password" {
  length = 12
  special = true
  override_special = "!#&$"
  keepers = {
    "keeper1" = var.name    #keeper changes = password for db changes
  }
}   

#pass can be seen > AWS Systems Manager >Parameter Store  or tfstate file


#save pass is ssm parameter
resource "aws_ssm_parameter" "rds_password" {
  name = "/prod/myysql"
  description = "Master Password for RDS MySQL"
  type = "SecureString"
  value = random_string.rds_password.result
}

#take pass from ssm
data "aws_ssm_parameter" "rds_pass" {
  name = "/prod/myysql"
  depends_on = [
    aws_ssm_parameter.rds_password
  ]
}

output "rds_password" {
  value = data.aws_ssm_parameter.rds_pass.value
  sensitive = true
}


#use pass from ssm param store
resource "aws_db_instance" "default" {
  identifier = "prod-rds"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "administrator"
  username             = "prod"
  password             = data.aws_ssm_parameter.rds_pass.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true  #when kill db = no snapshots
  apply_immediately = true  #all cgansed to db = immediately
}