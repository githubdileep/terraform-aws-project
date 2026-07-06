variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use. If empty, latest Amazon Linux 2023 is used."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
  default     = null
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}
