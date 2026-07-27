variable "project_name" {
  description = "Name prefix used for tagging and naming resources"
  type        = string
  default     = "scalable-web-app"
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones to deploy across (must match count of subnet CIDRs)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks for private application subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks for private database subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type for the web application tier"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "target_cpu_utilization" {
  description = "Target average CPU utilization (%) for target tracking scaling policy"
  type        = number
  default     = 60
}

variable "db_engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance (GB)"
  type        = number
  default     = 50
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the database (use a secrets manager / tfvars file, never commit real values)"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Root domain name managed in Route 53 (e.g. example.com)"
  type        = string
  default     = ""
}

variable "create_route53_zone" {
  description = "Whether Terraform should create the Route 53 hosted zone (set false if it already exists)"
  type        = bool
  default     = false
}

variable "alert_email" {
  description = "Email address to subscribe to SNS alarm notifications"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN (in the same region as the ALB) used for the HTTPS listener. Leave empty to deploy HTTP-only (not recommended for production)."
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "Optional EC2 key pair name (not required since access is via SSM Session Manager)"
  type        = string
  default     = ""
}
