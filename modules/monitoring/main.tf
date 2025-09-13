# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.environment}-webapp-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.asg_name],
            [".", "DiskReadBytes", ".", "."],
            [".", "DiskWriteBytes", ".", "."],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 Instance Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id],
            [".", "DatabaseConnections", ".", "."],
            [".", "FreeStorageSpace", ".", "."],
            [".", "FreeableMemory", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "RDS Metrics"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", "${var.environment}-webapp-alb", { "stat": "Sum" }],
            [".", "HTTPCode_Target_4XX_Count", ".", ".", { "stat": "Sum" }],
            [".", "HTTPCode_Target_5XX_Count", ".", ".", { "stat": "Sum" }],
            [".", "TargetResponseTime", ".", ".", { "stat": "Average" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "ALB Metrics"
        }
      }
    ]
  })
}

# SNS Topic for alerts (if not provided)
resource "aws_sns_topic" "alerts" {
  count = var.sns_topic_arn == "" ? 1 : 0
  name = "${var.environment}-alerts-topic"
}

# CloudWatch Alarm for high CPU on RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  
  alarm_description = "RDS CPU utilization is above 80%"
  alarm_actions     = var.sns_topic_arn != "" ? [var.sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

# CloudWatch Alarm for low storage on RDS
resource "aws_cloudwatch_metric_alarm" "rds_storage_low" {
  alarm_name          = "${var.environment}-rds-storage-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5368709120 # 5GB
  
  dimensions = {
    DBInstanceIdentifier = var.db_instance_id
  }
  
  alarm_description = "RDS free storage space is below 5GB"
  alarm_actions     = var.sns_topic_arn != "" ? [var.sns_topic_arn] : [aws_sns_topic.alerts[0].arn]
}

