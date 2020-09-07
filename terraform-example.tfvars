# Customize `whitelist_ip` and `keypair_path`
// Replace your outgoing ip below, use `curl -s ipinfo.io | jq .ip`
whitelist_ip = "w.x.y.z/32"

// Replace your private key location of your keypair
keypair_path = "</path/to/key.pem>"

// Replace your database name, username
database_name = "postgres"
database_username = "postgres"
// Uncomment below line and provide a new database password
# database_password = "SomeAwesomePassword!"
#

environment = "staging"
aws_region = "ap-northeast-1"

// VPC
vpc_name = "vpc"
vpc_cidr = "10.0.0.0/16"

performance_insights_enabled = true

// RDS PostgreSQL
rds_maz_identifier = "postgresql-maz"
rds_saz_identifier = "postgresql-saz"
rds_allocated_storage = 500
rds_storage_type = "io1"
rds_iops = 6000
rds_engine = "postgres"
rds_engine_version = "11.8"
rds_family = "postgres11"
rds_major_engine_version = "11"
rds_instance_class = "db.r5.8xlarge"
rds_parameter_group_name = "default.postgres11"
rds_skip_final_snapshot = true

// Aurora PostgreSQL
aurora_cluster_identifier = "aurora-postgresql-cluster"
aurora_instance_identifier_prefix = "aurora-instance"
aurora_instance_count = 2
aurora_engine = "aurora-postgresql"
aurora_engine_version = "11.8"
aurora_family = "postgres11"
aurora_major_engine_version = "11"
aurora_instance_class = "db.r5.8xlarge"
aurora_skip_final_snapshot = true
aurora_preferred_backup_window = "07:00-09:00"

// Benchmark Instance
benchmark_instance_class = "c5.9xlarge"

// Bastion Instance
bastion_instance_class = "t3.small"
