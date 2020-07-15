provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

module "postgres" {
  source            = "../modules/postgres"
  instance          = "db.t2.micro"
  identifier        = "prod"
  allocated_storage = "10"
  dbname            = "teamcity"
  engine_version    = "11.4"
  vpc_id            = module.vpc.vpc_id
  environment       = var.environment
  username          = var.rds_db_username
  password          = var.rds_db_password
  subnet_id         = module.vpc.aws_subnet_group_teamcity
}

module "vpc" {
  source       = "../modules/vpc"
  cluster-name = "terraform-eks-teamcity-${var.environment}"
}

module "teamcityeks" {
  source              = "../modules/teamcityeks"
  vpc_id              = module.vpc.vpc_id
  aws_subnet_teamcity = module.vpc.aws_subnet_teamcity_eks
}