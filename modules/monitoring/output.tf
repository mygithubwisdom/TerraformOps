output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = var.sns_topic_arn != "" ? var.sns_topic_arn : aws_sns_topic.alerts[0].arn
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

