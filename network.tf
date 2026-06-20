module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = local.name_prefix
  cidr = var.vpc_cidr

  azs              = var.availability_zones
  public_subnets   = var.public_subnet_cidrs
  private_subnets  = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_dns_hostnames = true
  enable_dns_support   = true
}

module "moodle_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name        = "${local.name_prefix}-web"
  description = "Permite trafego web e SSH controlado para Moodle"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = merge(
    {
      http = {
        cidr_ipv4   = "0.0.0.0/0"
        description = "HTTP publico para Moodle"
        from_port   = 80
        ip_protocol = "tcp"
        to_port     = 80
      }
    },
    {
      for index, cidr in var.ssh_allowed_cidrs : "ssh-${index}" => {
        cidr_ipv4   = cidr
        description = "SSH administrativo"
        from_port   = 22
        ip_protocol = "tcp"
        to_port     = 22
      }
    }
  )

  egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Saida para internet"
      ip_protocol = "-1"
    }
  }
}

module "database_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "6.0.0"

  name        = "${local.name_prefix}-database"
  description = "Permite MySQL somente a partir da instancia Moodle"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    mysql = {
      description                  = "MySQL a partir do Moodle"
      from_port                    = 3306
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.moodle_security_group.id
      to_port                      = 3306
    }
  }

  egress_rules = {
    all = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Saida para internet"
      ip_protocol = "-1"
    }
  }
}
