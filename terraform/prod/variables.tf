variable "aws_access_key" {
  description = "aws access key"
}

variable "aws_secret_key" {
  description = "aws secret key"
}

variable "region" {
  description = "region"
  default     = "us-east-2"
}
variable "environment" {
  description = "environment"
  default     = "prod"
}

variable "rds_db_username" {
  description = "database-username"
}

variable "rds_db_password" {
  description = "database-password"
}


