resource "aws_security_group" "alb" {
  name   = "${var.env}-alb-sg"
  vpc_id = var.vpc_id
  description = "SG for ALB"
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_security_group" "ec2" {
  name   = "${var.env}-ec2-sg"
  vpc_id = var.vpc_id
  description = "SG for EC2"
  ingress {
    description      = "HTTP from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}
output "ec2_sg_id" {
  value = aws_security_group.ec2.id
}