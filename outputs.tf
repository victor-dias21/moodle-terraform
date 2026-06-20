output "name_prefix" {
  description = "Prefixo comum usado nos recursos."
  value       = local.name_prefix
}

output "vpc_id" {
  description = "ID da VPC criada para o Moodle."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Subnets publicas usadas pela camada web."
  value       = module.vpc.public_subnets
}

output "database_subnet_ids" {
  description = "Subnets privadas usadas pelo RDS."
  value       = module.vpc.database_subnets
}

output "database_endpoint" {
  description = "Endpoint do RDS MySQL."
  value       = module.moodle_database.db_instance_endpoint
}

output "database_secret_arn" {
  description = "ARN do secret gerenciado pelo RDS para o usuario master."
  value       = module.moodle_database.db_instance_master_user_secret_arn
}

output "moodle_bucket_name" {
  description = "Nome do bucket S3 privado do Moodle."
  value       = module.moodle_bucket.s3_bucket_id
}
