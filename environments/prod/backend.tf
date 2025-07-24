terraform {
  backend "s3" {
    bucket         = "my-tf-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-tf-lock-table"
    encrypt        = true
  }
}