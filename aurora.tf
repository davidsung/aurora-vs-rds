resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "aurora-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name        = "aurora-subnet-group"
    Environment = var.environment
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = var.aurora_cluster_identifier
  engine             = var.aurora_engine
  availability_zones = data.aws_availability_zones.available.names
  database_name      = var.database_name
  master_username    = var.database_username
  master_password    = var.database_password

  preferred_backup_window = var.aurora_preferred_backup_window
  engine_version          = var.aurora_engine_version
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  skip_final_snapshot     = var.aurora_skip_final_snapshot
}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count                        = var.aurora_instance_count
  identifier                   = "${var.aurora_instance_identifier_prefix}-${count.index}"
  cluster_identifier           = aws_rds_cluster.aurora_cluster.id
  instance_class               = var.aurora_instance_class
  engine                       = aws_rds_cluster.aurora_cluster.engine
  engine_version               = aws_rds_cluster.aurora_cluster.engine_version
  db_subnet_group_name         = aws_db_subnet_group.aurora_subnet_group.name
  performance_insights_enabled = var.performance_insights_enabled
}
