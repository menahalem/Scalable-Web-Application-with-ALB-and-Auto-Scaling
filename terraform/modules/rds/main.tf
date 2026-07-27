############################################
# DB Subnet Group - spans the private DB subnets across AZs
############################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

############################################
# Parameter Group (placeholder for custom DB parameters)
############################################
resource "aws_db_parameter_group" "this" {
  name   = "${var.project_name}-db-params"
  family = var.db_parameter_group_family

  tags = {
    Name = "${var.project_name}-db-params"
  }
}

############################################
# RDS Multi-AZ Instance
############################################
resource "aws_db_instance" "this" {
  identifier     = "${var.project_name}-db"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_allocated_storage * 2
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_sg_id]
  parameter_group_name   = aws_db_parameter_group.this.name

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:30-mon:05:30"

  deletion_protection      = var.deletion_protection
  skip_final_snapshot      = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-final-snapshot"

  auto_minor_version_upgrade  = true
  copy_tags_to_snapshot       = true
  enabled_cloudwatch_logs_exports = var.db_engine == "mysql" ? ["error", "general", "slowquery"] : ["postgresql", "upgrade"]

  tags = {
    Name = "${var.project_name}-db"
  }
}
