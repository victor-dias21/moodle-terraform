module "moodle_database" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "${local.name_prefix}-mysql"

  engine               = "mysql"
  engine_version       = var.db_engine_version
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = var.db_instance_class

  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_allocated_storage * 2
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  port     = 3306

  manage_master_user_password = true

  multi_az               = false
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.database_security_group.id]

  maintenance_window      = "Sun:03:00-Sun:04:00"
  backup_window           = "04:00-05:00"
  backup_retention_period = var.db_backup_retention_period

  deletion_protection = false
  skip_final_snapshot = true
}

module "moodle_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.14.0"

  bucket        = "${local.name_prefix}-moodledata"
  force_destroy = var.force_destroy_bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}
