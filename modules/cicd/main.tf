# --- GitHub OIDC Provider ---
# IMPORTANT: This is a per-AWS-account resource. Only create it once
# (e.g. from the dev environment). Staging/prod should set
# create_oidc_provider = false and this module will look it up instead.
resource "aws_iam_openid_connect_provider" "github" {
  count           = var.create_oidc_provider ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_openid_connect_provider" "github" {
  count = var.create_oidc_provider ? 0 : 1
  url   = "https://token.actions.githubusercontent.com"
}

locals {
  github_oidc_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : data.aws_iam_openid_connect_provider.github[0].arn
}

# --- IAM Role assumable by GitHub Actions, scoped to this repo ---
resource "aws_iam_role" "github_actions" {
  name = "${var.environment}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = local.github_oidc_arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    }]
  })
}

# NOTE: This policy is intentionally broad for learning purposes.
# In a real org, scope each action down to specific resource ARNs
# (e.g. only the state bucket, only this account's EKS cluster, etc.)
resource "aws_iam_role_policy" "deploy_policy" {
  name = "${var.environment}-deploy-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*", "eks:*", "s3:*", "dynamodb:*",
          "lambda:*", "events:*", "elasticloadbalancing:*",
          "iam:GetRole", "iam:PassRole", "ecr:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_ecr_repository" "this" {
  name                 = "${var.environment}-${var.ecr_repo_name}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
  }
}
