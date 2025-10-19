# AWS ECS Fargate Capacity Provider Demo

This Terraform configuration demonstrates the **correct answer** to the AWS Solutions Architect exam question about cost-optimized ECS architectures for data analytics platforms.

## Question Context

**Question**: A data analytics platform runs containerized microservices on Amazon ECS with AWS Fargate. The platform processes large datasets and requires continuous operation with occasional traffic spikes during data processing jobs. The company needs to minimize costs while ensuring the platform remains available during peak processing times. The solution should automatically handle varying workloads without manual intervention. Which approach will provide the most cost-effective solution?

**Correct Answer**: Use ECS capacity provider with standard Fargate for baseline capacity and Fargate Spot for processing spikes.

## Architecture Overview

This demo implements the cost-optimized solution using:

- **Standard Fargate** for baseline capacity (1 task with weight 1) - ensures continuous operation
- **Fargate Spot** for processing spikes (0 base, weight 4) - provides cost-effective scaling
- **ECS Capacity Providers** to automatically manage the mixed compute strategy
- **Application Load Balancer** for traffic distribution
- **CloudWatch Logs** for monitoring and observability

## Key Features

### Cost Optimization Strategy

- **Baseline Capacity**: 1 task on standard Fargate (reliable, always available)
- **Spike Handling**: Up to 4 additional tasks on Fargate Spot (up to 70% cost savings)
- **Automatic Scaling**: ECS handles capacity provider selection based on availability and cost

### Infrastructure Components

- VPC with public and private subnets across 2 AZs
- ECS Cluster with Container Insights enabled
- Two capacity providers (standard Fargate + Fargate Spot)
- Application Load Balancer for high availability
- **Hardened Security Groups** with IP-based access control
- CloudWatch log group for centralized logging

### Security Features

- **IP Restriction**: ALB only accessible from your public IP address
- **Least Privilege**: ECS tasks only accept traffic from ALB
- **Restricted Egress**: ECS tasks limited to necessary outbound ports
- **Health Check Access**: VPC-internal health checks allowed
- **Simple IP Restriction**: Only your public IP is allowed access

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Access to AWS account in ap-southeast-2 region

## Deployment

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Review the configuration**:

   ```bash
   terraform plan
   ```

3. **Deploy the infrastructure**:

   ```bash
   terraform apply
   ```

4. **Get the ALB endpoint**:

   ```bash
   terraform output alb_dns_name
   ```

## Security Configuration

### IP-Based Access Control

The ALB is configured to only allow access from your current public IP address. This provides an additional layer of security for the demo.

**Your allowed IP**: Check with `terraform output allowed_public_ip`

### Security Group Details

- **ALB Security Group**: Only allows HTTP/HTTPS from your IP + VPC health checks
- **ECS Tasks Security Group**: Only allows traffic from ALB, restricted egress to necessary ports
- **No Public Access**: ECS tasks run in private subnets with no public IPs

## Testing the Demo

### 1. Verify Service Health

```bash
# Get the ALB DNS name
ALB_DNS=$(terraform output -raw alb_dns_name)

# Test the service
curl http://$ALB_DNS
```

### 2. Monitor Capacity Provider Usage

1. Go to AWS Console → ECS → Clusters
2. Select your cluster
3. Go to "Capacity providers" tab
4. Observe the capacity provider strategy configuration

### 3. Simulate Traffic Spikes

You can simulate traffic spikes by:

1. Scaling up the desired count: `terraform apply -var="desired_count=6"`
2. Monitoring which capacity provider handles the additional tasks
3. Observing cost differences in AWS Cost Explorer

## Cost Analysis

### Standard Fargate vs Fargate Spot

- **Standard Fargate**: ~$0.04048 per vCPU-hour, ~$0.004445 per GB-hour
- **Fargate Spot**: Up to 70% savings (typically 50-70% less than standard)

### Capacity Provider Strategy

- **Base**: 1 task on standard Fargate (ensures availability)
- **Weight**: 1:4 ratio (standard:spot)
- **Result**: Cost-optimized scaling with reliability guarantee

## Monitoring and Observability

### CloudWatch Logs

- **ECS Tasks**: `/ecs/{project_name}` - Container logs automatically streamed
- **ALB Access Logs**: `/aws/applicationloadbalancer/{project_name}` - Load balancer access logs
- **VPC Flow Logs**: `/aws/vpc/flowlogs/{project_name}` - Network traffic logs
- **Retention**: 1 day (configurable) for cost optimization
- **All log groups managed by Terraform** with proper lifecycle management

### ECS Console

- Service metrics and task health
- Capacity provider utilization
- Task placement history

## Cleanup

To avoid ongoing charges:

```bash
terraform destroy
```

## Key Learning Points

1. **Mixed Compute Strategy**: Combining standard and spot instances optimizes both cost and reliability
2. **Capacity Providers**: AWS-managed solution for automatic capacity selection
3. **Base vs Weight**: Base ensures minimum reliable capacity, weight determines scaling preference
4. **Fargate Spot Benefits**: Significant cost savings for fault-tolerant workloads
5. **Automatic Scaling**: No manual intervention required for capacity management

## Exam Relevance

This demo directly addresses the AWS Solutions Architect exam question by:

- ✅ Using standard Fargate for baseline capacity (continuous operation)
- ✅ Using Fargate Spot for processing spikes (cost optimization)
- ✅ Implementing ECS capacity providers (automatic management)
- ✅ Ensuring no manual intervention required
- ✅ Providing the most cost-effective solution

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_name` | Name of the project | `terraform-aws-demo-with-vpc-template` |
| `region` | AWS region | `ap-southeast-2` |
| `availability_zones` | List of AZs | `["ap-southeast-2a", "ap-southeast-2b"]` |
| `desired_count` | Desired number of ECS tasks | `2` |
| `task_cpu` | CPU units for ECS task | `256` (0.25 vCPU) |
| `task_memory` | Memory for ECS task in MB | `512` |

## Outputs

| Output | Description |
|--------|-------------|
| `alb_dns_name` | DNS name of the Application Load Balancer |
| `ecs_cluster_name` | Name of the ECS cluster |
| `capacity_provider_fargate` | Standard Fargate capacity provider name |
| `capacity_provider_fargate_spot` | Fargate Spot capacity provider name |
