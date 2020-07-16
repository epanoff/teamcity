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

variable "aws_subnet_teamcity_eks" {
  description = "subnets for sg"
}


