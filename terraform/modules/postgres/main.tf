resource "aws_db_instance" "teamcity-cluster" {
  identifier                  = var.identifier 
  allocated_storage           = var.allocated_storage
  storage_type                = "gp2"
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance
  name                        = var.dbname
  username                    = var.username
  password                    = var.password
  publicly_accessible         = "true"
  backup_window               = "08:00-08:30"
  backup_retention_period     = 14
  copy_tags_to_snapshot       = true
  multi_az                    = true
  vpc_security_group_ids      = [aws_security_group.teamcity-rds.id]
  db_subnet_group_name        = var.subnet_id.name
  skip_final_snapshot         = true
  allow_major_version_upgrade = true
  deletion_protection         = var.deletion_protection

  tags = {
    Name        = "rds-var.identifier"
    project     = "teamcity"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [instance_class]
  }
}

resource "aws_security_group" "teamcity-rds" {
  name        = "terraform-rds-teamcity-cluster"
  description = "Cluster communication with rds"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks"
  }
}