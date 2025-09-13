# Get the database secret from Secrets Manager
data "aws_secretsmanager_secret" "database" {
  arn = var.database_secret_arn
}

data "aws_secretsmanager_secret_version" "database" {
  secret_id = data.aws_secretsmanager_secret.database.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string)
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  
  tags = {
    Name = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}


# RDS Instance}
resource "aws_db_instance" "main" {
  identifier             = "${var.environment}-webapp-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.database_instance_class
  allocated_storage      = var.database_allocated_storage
  storage_type           = "gp2"
  db_name                = var.database_name
  username               = local.db_credentials.username
  password               = local.db_credentials.password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.database_security_group_id]
  multi_az               = var.environment == "prod" ? true : false
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot    = var.skip_final_snapshot
  final_snapshot_identifier = var.environment == "prod" ? "${var.environment}-final-snapshot" : null
  deletion_protection    = var.environment == "prod" ? true : false
  publicly_accessible    = false
  apply_immediately      = true
  
  tags = {
    Name = "${var.environment}-webapp-db"
    Environment = var.environment
  }
}
