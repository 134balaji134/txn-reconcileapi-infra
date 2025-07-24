variable "aws_region" {}
variable "aws_profile" {}
variable "env" {}
variable "cidr_block" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "tags" { type = map(string) }
variable "certificate_arn" {}
variable "ami_id" {}
variable "instance_type" {}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}