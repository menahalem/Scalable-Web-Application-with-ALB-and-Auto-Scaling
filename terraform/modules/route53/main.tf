############################################
# Hosted Zone (optional - create only if it doesn't already exist)
############################################
resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.domain_name
}

data "aws_route53_zone" "existing" {
  count = var.create_zone ? 0 : 1
  name  = var.domain_name
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

############################################
# Health Check on the ALB (used for failover / monitoring visibility)
############################################
resource "aws_route53_health_check" "alb" {
  fqdn              = var.alb_dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = var.health_check_path
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "${var.project_name}-alb-health-check"
  }
}

############################################
# Alias Record -> CloudFront distribution (recommended, static asset caching + latency)
# Falls back to ALB alias if use_cloudfront = false
############################################
resource "aws_route53_record" "app" {
  zone_id = local.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name = var.use_cloudfront ? var.cloudfront_domain_name : var.alb_dns_name
    zone_id = var.use_cloudfront ? var.cloudfront_hosted_zone_id : var.alb_zone_id
    evaluate_target_health = true
  }
}
