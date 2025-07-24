aws_region      = "us-east-1"
aws_profile     = "dev-profile"
env             = "dev"
cidr_block      = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
azs             = ["us-east-1a", "us-east-1b"]
tags            = { Environment = "dev" }
certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/dev"
ami_id          = "ami-xxxxxxxx"
instance_type   = "t3.micro"
desired_capacity = 2
min_size         = 2
max_size         = 4