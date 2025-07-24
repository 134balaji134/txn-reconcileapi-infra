aws_region      = "us-east-1"
aws_profile     = "prod-profile"
env             = "prod"
cidr_block      = "10.2.0.0/16"
public_subnets  = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnets = ["10.2.10.0/24", "10.2.11.0/24"]
azs             = ["us-east-1a", "us-east-1b"]
tags            = { Environment = "prod" }
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/prod"
ami_id          = "ami-zzzzzzzz"
instance_type   = "t3.large"
desired_capacity = 4
min_size         = 3
max_size         = 6