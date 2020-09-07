variable "environment" {
  description = "Environment"
  default = "staging"
}

variable "aws_region" {
  default = "ap-northeast-1"
}

// VPC
variable "vpc_name" {
  description = "VPC Name"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
}

variable "whitelist_ip" {
  description = "Whitelist IP"
}

// Common Database variables
variable "database_name" {
  description = "Database name"
}

variable "database_username" {
  description = "Database username"
}

variable "database_password" {
  description = "Database password"
}

// RDS
variable "rds_maz_identifier" {
  description = "RDS DB Multi-AZ Identifier"
}

variable "rds_saz_identifier" {
  description = "RDS DB Single-AZ Identifier"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
}

variable "rds_storage_type" {
  description = "RDS storage type, e.g. `gp2` or `io1`"
}

variable "rds_iops" {
  type = number
  description = "RDS provisioned IOPS"
}

variable "rds_engine" {
  # `aws rds describe-db-engine-versions --engine postgres | jq ".DBEngineVersions[].EngineVersion"`
  description = "Specifies Database Engine, `postgres` or `mysql`"
}

variable "rds_engine_version" {
  # `aws rds describe-db-engine-versions --engine postgres | jq ".DBEngineVersions[].EngineVersion"`
  description = "Specifies Database Engine Version, e.g. `11.8` or `12.3`"
}

variable "rds_instance_class" {
  description = "Specifies Database Instance Class, e.g. `db.r5.8xlarge`"
}

variable "rds_family" {
  description = "The family of the DB parameter group"
}

variable "rds_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with, e.g. `11`"
}

variable "rds_parameter_group_name" {
  description = "RDS parameter group name"
}

variable "rds_skip_final_snapshot" {
  type = bool
  description = "Skip final snapshot, true or false"
}

// Aurora
variable "aurora_cluster_identifier" {
  description = "Aurora Cluster Identifier"
}

variable "aurora_instance_identifier_prefix" {
  description = "Aurora Cluster Instance Identifier Prefix"
}

variable "aurora_instance_count" {
  description = "Aurora Instance Count"
}

variable "aurora_engine" {
  # `aws rds describe-db-engine-versions --engine postgres | jq ".DBEngineVersions[].EngineVersion"`
  description = "Specifies Database Engine, `postgres` or `mysql`"
}

variable "aurora_engine_version" {
  # `aws rds describe-db-engine-versions --engine postgres | jq ".DBEngineVersions[].EngineVersion"`
  description = "Specifies Database Engine Version, e.g. `11.8` or `12.3`"
}

variable "aurora_instance_class" {
  description = "Specifies Database Instance Class, e.g. `db.r5.8xlarge`"
}

variable "aurora_family" {
  description = "The family of the DB parameter group"
}

variable "aurora_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with, e.g. `11`"
}

variable "aurora_skip_final_snapshot" {
  type = bool
  description = "Skip Final Snapshot"
}

variable "performance_insights_enabled" {
  type = bool
  description = "Specifies whether Performance Insights is enabled or not."
}

variable "aurora_preferred_backup_window" {
  type = string
  description = "Preferred backup window"
}

// EC2 Instances
variable "keypair_path" {
  description = "Specifies the location of the private key of the keypair"
}

variable "benchmark_instance_class" {
  description = "Specifies Benchmark Instance Class, e.g. `r5.8xlarge`"
}

variable "bastion_instance_class" {
  description = "Specifies Bastion Instance Class, e.g. `t3.small`"
}
