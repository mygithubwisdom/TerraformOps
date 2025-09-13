output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "db_username" {
  description = "Username for the RDS instance"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.main.db_name
}

