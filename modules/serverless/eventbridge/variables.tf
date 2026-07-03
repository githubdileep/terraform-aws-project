variable "environment" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "schedule_expression" {
  description = "e.g. rate(1 day) or cron(0 12 * * ? *). Leave null if using event_pattern instead."
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "JSON event pattern for event-driven (non-scheduled) rules"
  type        = string
  default     = null
}

variable "lambda_function_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}
