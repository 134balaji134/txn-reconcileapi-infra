resource "aws_iam_role" "ec2" {
  name = "${var.env}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}
output "role_name" {
  value = aws_iam_role.ec2.name
}