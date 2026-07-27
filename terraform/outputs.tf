output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (use this or the Route 53 alias to access the app)"
  value       = module.cloudfront.distribution_domain_name
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS Multi-AZ instance"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN subscribed to CloudWatch alarms"
  value       = module.monitoring.sns_topic_arn
}

output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = module.monitoring.dashboard_name
}

output "route53_record_fqdn" {
  description = "Fully-qualified domain name of the Route 53 alias record (if a domain was provided)"
  value       = length(module.route53) > 0 ? module.route53[0].record_fqdn : null
}
