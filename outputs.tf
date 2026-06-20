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
