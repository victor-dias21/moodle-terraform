variable "project_name" {
  description = "Nome base usado nos recursos."
  type        = string
  default     = "moodle"
}

variable "environment" {
  description = "Ambiente do laboratorio."
  type        = string
  default     = "lab"
}

variable "aws_region" {
  description = "Regiao principal da AWS para os recursos."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Dominio publico do Moodle, por exemplo moodle.example.com."
  type        = string
}

variable "hosted_zone_name" {
  description = "Nome da zona publica no Route 53, por exemplo example.com."
  type        = string
}

variable "tags" {
  description = "Tags adicionais aplicadas aos recursos."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR principal da VPC."
  type        = string
  default     = "10.50.0.0/16"
}

variable "availability_zones" {
  description = "Zonas de disponibilidade usadas na VPC."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs das subnets publicas."
  type        = list(string)
  default     = ["10.50.0.0/24", "10.50.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas."
  type        = list(string)
  default     = ["10.50.10.0/24", "10.50.11.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDRs das subnets privadas do banco."
  type        = list(string)
  default     = ["10.50.20.0/24", "10.50.21.0/24"]
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs autorizados para SSH na instancia Moodle."
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Nome do banco de dados do Moodle."
  type        = string
  default     = "moodle"
}

variable "db_username" {
  description = "Usuario master do banco de dados."
  type        = string
  default     = "moodle"
}

variable "db_instance_class" {
  description = "Classe da instancia RDS."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Storage inicial do RDS em GiB."
  type        = number
  default     = 20
}

variable "db_engine_version" {
  description = "Versao do MySQL usada pelo RDS."
  type        = string
  default     = "8.0"
}

variable "db_backup_retention_period" {
  description = "Periodo de retencao de backups do RDS em dias."
  type        = number
  default     = 7
}

variable "force_destroy_bucket" {
  description = "Permite destruir o bucket S3 mesmo com objetos. Use apenas em laboratorio."
  type        = bool
  default     = false
}
