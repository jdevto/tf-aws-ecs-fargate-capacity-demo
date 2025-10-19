variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "ecs-fargate-demo"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want one NAT Gateway per availability zone. Otherwise, one NAT Gateway will be used for all AZs."
  type        = bool
  default     = false
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "CPU units for the ECS task (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the ECS task in MB"
  type        = number
  default     = 512
}
