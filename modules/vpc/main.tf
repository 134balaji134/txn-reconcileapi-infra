resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.azs[each.key]
  map_public_ip_on_launch = true
  tags = var.tags
}

resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.azs[each.key]
  tags = var.tags
}

output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}
output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}