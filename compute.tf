resource "random_password" "moodle_admin" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "moodle_admin" {
  name_prefix = "${local.name_prefix}-admin-"
  description = "Senha inicial do administrador Moodle"
}

resource "aws_secretsmanager_secret_version" "moodle_admin" {
  secret_id = aws_secretsmanager_secret.moodle_admin.id
  secret_string = jsonencode({
    username = var.moodle_admin_user
    password = random_password.moodle_admin.result
  })
}

data "aws_iam_policy_document" "moodle_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "moodle_instance" {
  statement {
    sid = "ReadMoodleSecrets"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      module.moodle_database.db_instance_master_user_secret_arn,
      aws_secretsmanager_secret.moodle_admin.arn
    ]
  }

  statement {
    sid = "UseMoodleBucket"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]

    resources = [
      module.moodle_bucket.s3_bucket_arn,
      "${module.moodle_bucket.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role" "moodle_instance" {
  name               = "${local.name_prefix}-ec2"
  assume_role_policy = data.aws_iam_policy_document.moodle_assume_role.json
}

resource "aws_iam_role_policy" "moodle_instance" {
  name   = "${local.name_prefix}-ec2"
  role   = aws_iam_role.moodle_instance.id
  policy = data.aws_iam_policy_document.moodle_instance.json
}

resource "aws_iam_instance_profile" "moodle_instance" {
  name = "${local.name_prefix}-ec2"
  role = aws_iam_role.moodle_instance.name
}

module "moodle_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name = "${local.name_prefix}-web"

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.moodle_security_group.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.moodle_instance.name

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/templates/user_data_moodle.sh.tftpl", {
    aws_region              = var.aws_region
    db_name                 = var.db_name
    db_secret_arn           = module.moodle_database.db_instance_master_user_secret_arn
    db_endpoint             = module.moodle_database.db_instance_address
    db_username             = var.db_username
    moodle_admin_email      = var.moodle_admin_email
    moodle_admin_secret_arn = aws_secretsmanager_secret.moodle_admin.arn
    moodle_admin_user       = var.moodle_admin_user
    moodle_fullname         = var.moodle_fullname
    moodle_shortname        = var.moodle_shortname
    moodle_url              = "https://${var.domain_name}"
    s3_bucket_name          = module.moodle_bucket.s3_bucket_id
  })

  root_block_device = {
    size      = var.root_volume_size
    type      = "gp3"
    encrypted = true
  }
}
