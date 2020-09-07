###############
# RDS Single AZ
###############
resource "aws_db_subnet_group" "rds_saz_subnet_group" {
  name       = "rds-saz-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name        = "rds-saz-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "postgresql_saz" {
  identifier                   = var.rds_saz_identifier
  allocated_storage            = var.rds_allocated_storage
  storage_type                 = var.rds_storage_type
  iops                         = var.rds_iops
  engine                       = var.rds_engine
  engine_version               = var.rds_engine_version
  instance_class               = var.rds_instance_class
  parameter_group_name         = var.rds_parameter_group_name
  multi_az                     = false
  availability_zone            = aws_db_instance.postgresql_maz.availability_zone
  db_subnet_group_name         = aws_db_subnet_group.rds_saz_subnet_group.name
  vpc_security_group_ids       = [aws_security_group.db_sg.id]
  skip_final_snapshot          = var.rds_skip_final_snapshot
  performance_insights_enabled = var.performance_insights_enabled

  name     = var.database_name
  username = var.database_username
  password = var.database_password
}
