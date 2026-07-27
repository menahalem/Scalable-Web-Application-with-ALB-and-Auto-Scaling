variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "alert_email" {
  type    = string
  default = ""
}

variable "asg_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "db_instance_id" {
  type = string
}
