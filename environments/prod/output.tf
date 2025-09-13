output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.database.db_endpoint
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = module.monitoring.dashboard_name
}

