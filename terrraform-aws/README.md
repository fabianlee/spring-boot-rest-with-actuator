# Terraform Configuration for Spring Boot WebSocket on ECS

This Terraform configuration deploys the Spring Boot WebSocket application to AWS ECS with an Application Load Balancer (ALB).

## Architecture Overview

- **VPC**: Custom VPC with public and private subnets across multiple availability zones
- **ECS Cluster**: Fargate-based ECS cluster with Container Insights enabled
- **ECS Service**: Manages containerized Spring Boot application with auto-scaling
- **Application Load Balancer**: Exposes the application on port 80 (or 443 with SSL)
- **Auto-scaling**: CPU and memory-based scaling policies
- **Logging**: CloudWatch log group for application logs

## Prerequisites

1. **Terraform** >= 1.0
2. **AWS CLI** configured with appropriate credentials
3. **Docker image** pushed to ECR (Elastic Container Registry)
4. **AWS Account** with appropriate permissions

## Setup Instructions

### 1. Build and Push Docker Image to ECR

```bash
# Get your AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"

# Create ECR repository
aws ecr create-repository \
  --repository-name spring-boot-websocket \
  --region $AWS_REGION

# Build the Docker image
docker build -t spring-boot-websocket:latest .

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin \
  $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag the image
docker tag spring-boot-websocket:latest \
  $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/spring-boot-websocket:latest

# Push to ECR
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/spring-boot-websocket:latest
```

### 2. Configure Terraform Variables

Copy the example file and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `ecr_repository_url`: Your ECR image URL
- Other variables as needed

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review and Apply Configuration

```bash
# Review the planned changes
terraform plan

# Apply the configuration
terraform apply
```

### 5. Access the Application

Once deployed, the application will be accessible via the ALB DNS name:

```bash
terraform output application_url
```

## Configuration Options

### Container Resources

Adjust CPU and memory in `terraform.tfvars`:
- `container_cpu`: CPU units (256 = 0.25 vCPU, 512 = 0.5 vCPU, 1024 = 1 vCPU)
- `container_memory`: Memory in MB (512, 1024, 2048, 4096, etc.)

Supported CPU/Memory combinations:
- 256 CPU: 512-2048 MB
- 512 CPU: 1024-4096 MB
- 1024 CPU: 2048-8192 MB
- 2048 CPU: 4096-16384 MB
- 4096 CPU: 8192-30720 MB

### Auto-scaling

Adjust in `terraform.tfvars`:
- `min_capacity`: Minimum number of running tasks
- `max_capacity`: Maximum number of running tasks
- `cpu_target`: Target CPU utilization percentage
- `memory_target`: Target memory utilization percentage

### SSL/TLS

To enable HTTPS:

1. Create or import a certificate in AWS Certificate Manager
2. Update `terraform.tfvars`:
   ```
   enable_ssl = true
   ssl_certificate_arn = "arn:aws:acm:region:account:certificate/id"
   alb_port = 443  # Change to 443 for HTTPS
   ```

## Important Notes

### Port Configuration

- The Spring Boot application runs on port **8080** inside the container
- The ALB listener is exposed on port **80** (HTTP) by default
- The ALB forwards traffic to the target group on port 8080
- The container port is configurable via `container_port` variable

### Security Groups

- **ALB Security Group**: Allows inbound traffic on ports 80/443 from 0.0.0.0/0
- **ECS Tasks Security Group**: Allows inbound traffic on port 8080 only from ALB

### Network Configuration

- ECS tasks run in private subnets for security
- NAT Gateways in public subnets enable outbound internet access from private subnets
- No public IP assigned to ECS tasks

## Useful Commands

```bash
# View outputs
terraform output

# Get specific output
terraform output alb_dns_name

# View logs
aws logs tail /ecs/spring-boot-websocket --follow

# View running tasks
aws ecs list-tasks --cluster spring-boot-websocket-cluster

# View task details
aws ecs describe-tasks --cluster spring-boot-websocket-cluster \
  --tasks <task-arn>

# Stop and restart ECS service
terraform apply -var="desired_count=0"  # Stop
terraform apply -var="desired_count=2"  # Restart

# Clean up all resources
terraform destroy
```

## Troubleshooting

### Tasks failing to start

Check CloudWatch logs:
```bash
aws logs tail /ecs/spring-boot-websocket --follow
```

### Health check failures

Verify the application is responding on port 8080:
- Check security group rules
- Verify application logs in CloudWatch
- Update health check path if needed

### ALB not routing traffic

Check target group health:
```bash
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
```

## Cost Optimization

1. **Reduce task count**: Set `desired_count = 1` for development
2. **Use smaller resources**: Reduce `container_cpu` and `container_memory`
3. **Adjust auto-scaling**: Increase `min_capacity` threshold for less frequent scaling
4. **Use NAT Gateway selectively**: Only needed if tasks require outbound internet

## Cleanup

Remove all AWS resources:

```bash
terraform destroy
```

## Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Spring Boot on AWS](https://docs.spring.io/spring-cloud-aws/docs/current/reference/html/)
