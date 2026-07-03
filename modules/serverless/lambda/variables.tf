variable "environment" {
  type = string
}

variable "function_name" {
  type = string
}

variable "source_dir" {
  description = "Local directory containing the Lambda source code to zip"
  type        = string
}

variable "handler" {
  type    = string
  default = "index.handler"
}

variable "runtime" {
  type    = string
  default = "python3.12"
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 30
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}
