variable "project_name" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "domain_aliases" {
  description = "Alternate domain names (CNAMEs) for the distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM cert ARN in us-east-1 for the CloudFront distribution custom domain; leave empty to use the default CloudFront certificate"
  type        = string
  default     = ""
}

variable "price_class" {
  type    = string
  default = "PriceClass_100"
}

variable "waf_web_acl_arn" {
  description = "ARN of a CLOUDFRONT-scope (us-east-1) WAF WebACL. Note: this must be a separate WebACL from the REGIONAL one used by the ALB. Leave empty to skip."
  type        = string
  default     = ""
}
