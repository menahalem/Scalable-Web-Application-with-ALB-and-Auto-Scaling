variable "project_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "record_name" {
  description = "Subdomain/record name to create (e.g. www.example.com or example.com)"
  type        = string
}

variable "create_zone" {
  type    = bool
  default = false
}

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "use_cloudfront" {
  type    = bool
  default = true
}

variable "cloudfront_domain_name" {
  type    = string
  default = ""
}

variable "cloudfront_hosted_zone_id" {
  type    = string
  default = ""
}

variable "health_check_path" {
  type    = string
  default = "/health"
}
