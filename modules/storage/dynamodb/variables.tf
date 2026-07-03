variable "environment" {
  type = string
}

variable "table_name" {
  type = string
}

variable "hash_key" {
  type = string
}

variable "hash_key_type" {
  description = "S = String, N = Number, B = Binary"
  type        = string
  default     = "S"
}

variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST"
}
