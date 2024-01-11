provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = "us-east-1"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "Counter"
      Provisioned = "Terraform"
    }
  }
}


# DynamoDB





# API Gateway





# Lambda