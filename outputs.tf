output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.this.zone_id
}

output "capacity_provider_fargate" {
  description = "Standard Fargate capacity provider name"
  value       = "FARGATE"
}

output "capacity_provider_fargate_spot" {
  description = "Fargate Spot capacity provider name"
  value       = "FARGATE_SPOT"
}

output "cloudwatch_log_group_ecs" {
  description = "CloudWatch log group for ECS tasks"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "cloudwatch_log_group_alb" {
  description = "CloudWatch log group for ALB access logs"
  value       = aws_cloudwatch_log_group.alb.name
}

output "cloudwatch_log_group_vpc_flow_logs" {
  description = "CloudWatch log group for VPC flow logs"
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}

output "cloudwatch_log_group_ecs_container_insights" {
  description = "CloudWatch log group for ECS Container Insights"
  value       = aws_cloudwatch_log_group.ecs_container_insights.name
}

output "allowed_public_ip" {
  description = "Your current public IP address that is allowed to access the ALB"
  value       = chomp(data.http.my_public_ip.response_body)
}

output "security_note" {
  description = "Security configuration note"
  value       = "ALB is restricted to your public IP only for demo security."
}
