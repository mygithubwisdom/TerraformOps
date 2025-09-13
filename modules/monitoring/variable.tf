variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "db_instance_id" {
  description = "ID of the RDS instance"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic for notifications"
  type        = string
  default     = ""
}

