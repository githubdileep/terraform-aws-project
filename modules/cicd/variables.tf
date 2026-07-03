variable "environment" {
  type = string
}

variable "github_org" {
  description = "GitHub org or username, e.g. 'dileep'"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo name, e.g. 'terraform-aws-project'"
  type        = string
}

variable "ecr_repo_name" {
  type = string
}

variable "create_oidc_provider" {
  description = "Set true only in ONE environment (e.g. dev). The GitHub OIDC provider is a single per-AWS-account resource and creating it twice will fail. Other environments should set this to false."
  type        = bool
  default     = true
}
