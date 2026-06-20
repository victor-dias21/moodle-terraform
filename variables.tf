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
