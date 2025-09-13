# Read user_data from file at root level
data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    db_endpoint = module.database.db_endpoint
    db_name     = module.database.db_name
    secret_arn  = module.secrets.database_secret_arn
  }
}

# Secrets module
module "secrets" {
  source = "../../modules/secrets"
  
  environment   = "prod" 
  database_name = "webappdb"
}

# Networking module
module "networking" {
  source = "../../modules/networking"
  
  environment          = "prod"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

# Database module
module "database" {
  source = "../../modules/database"
  
  environment               = "prod" 
  private_subnet_ids        = module.networking.private_subnet_ids
  database_security_group_id = module.networking.database_security_group_id
  database_name             = "webappdb"
  database_secret_arn       = module.secrets.database_secret_arn # Reference the secret ARN
  database_instance_class   = "db.t3.micro"
  database_allocated_storage = 100
  skip_final_snapshot       = false
  deletion_protection    = true
  backup_retention_period   = 14
  depends_on = [module.secrets]
}

# Compute module
module "compute" {
  source = "../../modules/compute"
  
  environment            = "prod"
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  private_subnet_ids     = module.networking.private_subnet_ids
  alb_security_group_id  = module.networking.alb_security_group_id
  web_security_group_id  = module.networking.web_security_group_id
  db_endpoint            = module.database.db_endpoint
  db_name                = module.database.db_name
  database_secret_arn    = module.secrets.database_secret_arn # Reference the secret ARN
  instance_type          = "t3.medium"
  min_size               = 3
  max_size               = 10
  desired_capacity       = 3
  key_name               = null
  user_data = data.template_file.user_data.rendered
}

# Monitoring module
module "monitoring" {
  source = "../../modules/monitoring"
  
  environment   = "prod"
  asg_name      = module.compute.asg_name
  db_instance_id = module.database.db_instance_id
}



