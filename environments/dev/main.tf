provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source          = "../../modules/vpc"
  cidr_block      = var.cidr_block
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = var.tags
}

module "sg" {
  source = "../../modules/sg"
  env    = var.env
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "iam" {
  source = "../../modules/iam"
  env    = var.env
  tags   = var.tags
}

module "alb" {
  source            = "../../modules/alb"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.sg.alb_sg_id
  certificate_arn   = var.certificate_arn
  tags              = var.tags
}

module "ec2" {
  source                = "../../modules/ec2"
  env                   = var.env
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  private_subnet_ids    = module.vpc.private_subnet_ids
  ec2_sg_id             = module.sg.ec2_sg_id
  user_data             = file("../../scripts/user_data.sh")
  desired_capacity      = var.desired_capacity
  min_size              = var.min_size
  max_size              = var.max_size
  target_group_arn      = module.alb.target_group_arn
  instance_profile_name = module.iam.instance_profile_name
  tags                  = var.tags
}