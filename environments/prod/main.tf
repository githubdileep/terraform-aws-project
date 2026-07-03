module "networking" {
  source = "../../modules/networking"

  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  azs                   = var.azs
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  single_nat_gateway    = false  # prod: one NAT Gateway per AZ for high availability
}

module "security" {
  source = "../../modules/security"

  environment = var.environment
  vpc_id      = module.networking.vpc_id
  vpc_cidr    = module.networking.vpc_cidr
}

module "ec2" {
  source = "../../modules/compute/ec2"

  environment         = var.environment
  subnet_id           = module.networking.private_subnet_ids[0]
  security_group_ids  = [module.security.ec2_sg_id]
  instance_type       = "t3.small"
  instance_count      = 1
}

module "eks" {
  source = "../../modules/compute/eks"

  environment         = var.environment
  private_subnet_ids  = module.networking.private_subnet_ids
  public_subnet_ids   = module.networking.public_subnet_ids
  cluster_sg_id       = module.security.eks_cluster_sg_id
  node_instance_types = ["t3.medium"]
  node_desired_size   = 1
  node_min_size       = 1
  node_max_size       = 2
}

module "alb" {
  source = "../../modules/networking-alb"

  environment       = var.environment
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  target_port       = 30080
  target_type       = "instance"
}

module "s3_app" {
  source = "../../modules/storage/s3"

  environment   = var.environment
  bucket_suffix = "app-data"
}

module "dynamodb_app" {
  source = "../../modules/storage/dynamodb"

  environment = var.environment
  table_name  = "app-table"
  hash_key    = "id"
}

module "lambda_hello" {
  source = "../../modules/serverless/lambda"

  environment   = var.environment
  function_name = "hello-world"
  source_dir    = "${path.module}/../../lambda-src/hello-world"
}

module "eventbridge_hello" {
  source = "../../modules/serverless/eventbridge"

  environment           = var.environment
  rule_name              = "hello-schedule"
  schedule_expression    = "rate(1 day)"
  lambda_function_arn    = module.lambda_hello.function_arn
  lambda_function_name   = module.lambda_hello.function_name
}

module "cicd" {
  source = "../../modules/cicd"

  environment           = var.environment
  github_org            = var.github_org
  github_repo           = var.github_repo
  ecr_repo_name         = "app"
  create_oidc_provider  = false  # dev already created the account-wide OIDC provider
}
