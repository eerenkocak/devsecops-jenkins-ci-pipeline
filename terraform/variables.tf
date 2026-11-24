variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins controller (Constrained by FinOps)"
  type        = string
  default     = "t3.small"

  validation {
    condition     = contains(["t3.small", "t3.medium"], var.instance_type)
    error_message = "FinOps Guardrail: Jenkins requires at least t3.small (2GB RAM) and is capped at t3.medium."
  }
}
