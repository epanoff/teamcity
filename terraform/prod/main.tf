provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

module "postgres" {
  source = "../modules/postgres"
  instance = "t2.micro"
  identifier = "prod"
  allocated_storage = "10"
  dbname = "teamcity"
  engine_version = "11.4"
  environment = var.environment
}

module "vpc" {
  source = "../modules/vpc"
  cluster-name = "terraform-eks-teamcity-${var.environment}"
}

module "teamcityeks" {
  source = "../modules/teamcityeks"
  vpc_id = module.vpc.vpc_id
  aws_subnet_teamcity = module.vpc.aws_subnet_teamcity
}