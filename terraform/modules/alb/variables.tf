variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener; leave empty to skip HTTPS listener creation"
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs; leave empty to disable"
  type        = string
  default     = ""
}
