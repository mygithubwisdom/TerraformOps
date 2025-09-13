// output.tf for dev environment
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "database_endpoint" {
  description = "Database Endpoint"
  value       = module.database.db_endpoint
  sensitive = true
}

output "database_port" {
  description = "Database Port"
  value       = module.database.db_port
}