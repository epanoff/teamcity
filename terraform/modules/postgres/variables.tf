#variable "sg_id" {
#  type        = list
#  description = "aws security group id"
#}

#variable "subnet_id" {
#  description = "aws subnet id"
#}

#variable "region" {
#  description = "aws region"
#}


variable "instance" {
  description = "aws instance"
}

variable "identifier" {
  description = "aws rds identifier"
}

variable "allocated_storage" {
  description = "allocated storage"
}

variable "username" {
  description = "database-username"
}

variable "password" {
  description = "database-password"
}

variable "deletion_protection" {
  default = false
}

variable "environment" {
  description = "environment"
}

variable "dbname" {}

variable "engine_version" {
  
}

variable "vpc_id" {
  description = "vpc_id"
}
variable "subnet_id" {
  description = "subnet_name"
}

