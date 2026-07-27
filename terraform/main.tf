############################################
# VPC - subnets, route tables, NAT gateways, NACLs
############################################
module "vpc" {
  source = "./modules/vpc"

  project_name              = var.project_name
  vpc_cidr                  = var.vpc_cidr
  availability_zones        = var.availability_zones
  public_subnet_cidrs       = var.public_subnet_cidrs
  private_app_subnet_cidrs  = var.private_app_subnet_cidrs
  private_db_subnet_cidrs   = var.private_db_subnet_cidrs
}

############################################
# Security Groups
############################################
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  db_port      = var.db_engine == "postgres" ? 5432 : 3306
}

############################################
# ALB + WAF
############################################
module "alb" {
  source = "./modules/alb"

  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  health_check_path  = "/health"

  # Provide an ACM certificate ARN (validated in this region) to enable HTTPS listener
  acm_certificate_arn = var.acm_certificate_arn
}

############################################
# Auto Scaling Group + Launch Template
############################################
module "asg" {
  source = "./modules/asg"

  project_name             = var.project_name
  instance_type             = var.instance_type
  app_sg_id                 = module.security.app_sg_id
  private_app_subnet_ids    = module.vpc.private_app_subnet_ids
  target_group_arn          = module.alb.target_group_arn
  target_group_arn_suffix   = module.alb.target_group_arn_suffix
  asg_min_size              = var.asg_min_size
  asg_max_size              = var.asg_max_size
  asg_desired_capacity      = var.asg_desired_capacity
  target_cpu_utilization    = var.target_cpu_utilization
  key_pair_name             = var.key_pair_name
}

############################################
# RDS Multi-AZ
############################################
module "rds" {
  source = "./modules/rds"

  project_name              = var.project_name
  private_db_subnet_ids     = module.vpc.private_db_subnet_ids
  db_sg_id                  = module.security.db_sg_id
  db_engine                 = var.db_engine
  db_engine_version         = var.db_engine_version
  db_instance_class         = var.db_instance_class
  db_allocated_storage      = var.db_allocated_storage
  db_name                   = var.db_name
  db_username               = var.db_username
  db_password               = var.db_password
  db_port                   = var.db_engine == "postgres" ? 5432 : 3306
  db_parameter_group_family = var.db_engine == "postgres" ? "postgres15" : "mysql8.0"
}

############################################
# CloudFront - caches static assets, fronts the ALB
############################################
module "cloudfront" {
  source = "./modules/cloudfront"

  project_name = var.project_name
  alb_dns_name = module.alb.alb_dns_name
}

############################################
# Route 53 - Alias record + health check
############################################
module "route53" {
  count  = var.domain_name != "" ? 1 : 0
  source = "./modules/route53"

  project_name              = var.project_name
  domain_name               = var.domain_name
  record_name               = var.domain_name
  create_zone               = var.create_route53_zone
  alb_dns_name               = module.alb.alb_dns_name
  alb_zone_id               = data.aws_lb.selected.zone_id
  use_cloudfront             = true
  cloudfront_domain_name    = module.cloudfront.distribution_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.distribution_hosted_zone_id
}

# Helper data source to fetch the ALB's canonical hosted zone ID for Route 53 alias records
data "aws_lb" "selected" {
  arn = module.alb.alb_arn
}

############################################
# CloudWatch + SNS Monitoring
############################################
module "monitoring" {
  source = "./modules/monitoring"

  project_name              = var.project_name
  aws_region                 = var.aws_region
  alert_email                = var.alert_email
  asg_name                   = module.asg.asg_name
  alb_arn_suffix             = data.aws_lb.selected.arn_suffix
  target_group_arn_suffix    = module.alb.target_group_arn_suffix
  db_instance_id             = module.rds.db_instance_id
}
