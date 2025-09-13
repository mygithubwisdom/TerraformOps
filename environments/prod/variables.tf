# environments/dev/variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "webapp"
    ManagedBy   = "terraform"
  }
}

