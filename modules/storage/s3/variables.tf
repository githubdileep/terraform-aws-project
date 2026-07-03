variable "environment" {
  type = string
}

variable "bucket_suffix" {
  description = "Unique suffix appended to bucket name, e.g. 'app-data'"
  type        = string
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "force_destroy" {
  description = "Allow terraform destroy to delete a non-empty bucket (dev/testing only)"
  type        = bool
  default     = false
}
