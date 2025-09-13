variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1" // You can change this default value as needed
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = [""]  
  
}
// Add these data base variables
  variable db_password {
    description = "Database password"
    type       = string
    sensitive  = true
  }

  // Monitoring variables
  variable "monitoring_enabled" {
    description = "Email address for monitoring alerts"
    type        = string
    default     = true
  }