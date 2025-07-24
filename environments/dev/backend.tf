terraform {
  backend "s3" {
    bucket         = "my-tf-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-tf-lock-table"
    encrypt        = true
  }
}