variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "target_port" {
  description = "Port the ALB forwards traffic to (e.g. NodePort of your K8s service, or EC2 app port)"
  type        = number
  default     = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "target_type" {
  description = "instance | ip | lambda"
  type        = string
  default     = "instance"
}
