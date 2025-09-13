variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "database_security_group_id" {
  description = "ID of the database security group"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "webappdb"
}


variable "database_secret_arn" {
  description = "ARN of the database secret in AWS Secrets Manager"
  type        = string
}

variable "database_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "database_allocated_storage" {
  description = "Database allocated storage in GB"
  type        = number
  default     = 20
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying DB"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Enable deletion protection for RDS"
  type        = bool
  default     = false
}

