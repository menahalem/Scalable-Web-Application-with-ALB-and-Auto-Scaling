variable "project_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "app_sg_id" {
  type = string
}

variable "private_app_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group, used for CloudWatch alarm dimensions"
  type        = string
}

variable "asg_min_size" {
  type = number
}

variable "asg_max_size" {
  type = number
}

variable "asg_desired_capacity" {
  type = number
}

variable "target_cpu_utilization" {
  type = number
}

variable "key_pair_name" {
  type    = string
  default = ""
}
