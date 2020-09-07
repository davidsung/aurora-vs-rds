# Output values
output "aurora_writer_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}

output "aurora_availability_zones" {
  value = aws_rds_cluster.aurora_cluster.availability_zones
}

output "rds_maz_endpoint" {
  value = aws_db_instance.postgresql_maz.address
}

output "rds_maz_availability_zone" {
  value = aws_db_instance.postgresql_maz.availability_zone
}

output "rds_saz_endpoint" {
  value = aws_db_instance.postgresql_saz.address
}

output "rds_saz_availability_zone" {
  value = aws_db_instance.postgresql_saz.availability_zone
}

output "benchmark_endpoint" {
  value = aws_instance.benchmark.private_dns
}

output "bastion_endpoint" {
  value = aws_instance.bastion.public_dns
}
