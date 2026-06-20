module "moodle_dns" {
  source  = "terraform-aws-modules/route53/aws"
  version = "6.5.0"

  name    = var.hosted_zone_name
  comment = "Zona publica para o laboratorio Moodle Terraform"
}

module "moodle_certificate" {
  source  = "terraform-aws-modules/acm/aws"
  version = "6.3.0"

  providers = {
    aws = aws.us_east_1
  }

  domain_name       = var.domain_name
  zone_id           = module.moodle_dns.id
  validation_method = "DNS"

  wait_for_validation = true
}

module "moodle_cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "6.7.0"

  aliases = [var.domain_name]
  comment = "CDN para Moodle Terraform Lab"
  enabled = true

  http_version    = "http2and3"
  is_ipv6_enabled = true
  price_class     = var.cloudfront_price_class

  origin = {
    moodle = {
      domain_name = module.moodle_instance.public_dns

      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "moodle"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    forwarded_values = {
      query_string = true
      cookies = {
        forward = "all"
      }
    }
  }

  viewer_certificate = {
    acm_certificate_arn      = module.moodle_certificate.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "moodle" {
  zone_id = module.moodle_dns.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.moodle_cdn.cloudfront_distribution_domain_name
    zone_id                = module.moodle_cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
