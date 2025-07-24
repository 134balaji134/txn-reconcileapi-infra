aws_region      = "us-east-1"
aws_profile     = "stg-profile"
env             = "stg"
cidr_block      = "10.1.0.0/16"
public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets = ["10.1.10.0/24", "10.1.11.0/24"]
azs             = ["us-east-1a", "us-east-1b"]
tags            = { Environment = "stg" }
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/stg"
ami_id          = "ami-yyyyyyyy"
instance_type   = "t3.medium"
desired_capacity = 3
min_size         = 2
max_size         = 5