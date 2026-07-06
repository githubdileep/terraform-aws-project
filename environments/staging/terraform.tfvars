environment          = "staging"
vpc_cidr             = "10.1.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

github_org  = "githubdileep"
github_repo = "terraform-aws-project"
