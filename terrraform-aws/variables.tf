variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "spring-boot-websocket"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "ecs_task_definition_family" {
  description = "Family name for ECS task definition"
  type        = string
  default     = "spring-boot-websocket"
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "spring-boot-websocket-service"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "spring-boot-websocket-cluster"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "spring-boot-websocket"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "container_cpu" {
  description = "CPU units for container (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "Memory in MB for container"
  type        = number
  default     = 512
}

variable "ecr_repository_url" {
  description = "ECR repository URL for Docker image"
  type        = string
}

variable "app_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "alb_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}

variable "enable_ssl" {
  description = "Enable SSL/TLS on ALB"
  type        = bool
  default     = false
}

variable "ssl_certificate_arn" {
  description = "ACM certificate ARN for HTTPS (required if enable_ssl is true)"
  type        = string
  default     = ""
}

variable "min_capacity" {
  description = "Minimum number of tasks for auto-scaling"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of tasks for auto-scaling"
  type        = number
  default     = 4
}

variable "cpu_target" {
  description = "Target CPU utilization for auto-scaling"
  type        = number
  default     = 70
}

variable "memory_target" {
  description = "Target memory utilization for auto-scaling"
  type        = number
  default     = 80
}
