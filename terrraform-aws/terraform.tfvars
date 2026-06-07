# AWS Configuration
aws_region = "us-east-1"
environment = "dev"
project_name = "spring-boot-websocket"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# ECS Configuration
ecs_cluster_name = "spring-boot-websocket-cluster"
ecs_service_name = "spring-boot-websocket-service"
ecs_task_definition_family = "spring-boot-websocket"
container_name = "spring-boot-websocket"
container_port = 8080

# Task Configuration
desired_count = 1
container_cpu = 256        # 0.25 vCPU
container_memory = 512     # 512 MB

# Auto-scaling Configuration
min_capacity = 1
max_capacity = 4
cpu_target = 70            # 70% CPU utilization
memory_target = 80         # 80% memory utilization

# ECR Image
# Replace with your ECR repository URL
# ecr_repository_url = "ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/spring-boot-websocket:latest"
ecr_repository_url = "ghcr.io/fabianlee/spring-boot-websocket-aws:latest"

# ALB Configuration
alb_port = 80
enable_ssl = false
# ssl_certificate_arn = "arn:aws:acm:us-east-1:ACCOUNT_ID:certificate/CERTIFICATE_ID"  # Required if enable_ssl = true

# Logging
app_log_retention_days = 7
