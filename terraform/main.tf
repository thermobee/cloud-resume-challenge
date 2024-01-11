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

# USE VARIABLES

# DynamoDB
resource "aws_dynamodb_table" "VisitsCountTable" {
  name         = "CountTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "visitCount"
    type = S
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "visitsCountAPITF" {
  name = "visitsCountAPITF"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resouce" "myResource" {
  parent_id   = aws_api_gateway_rest_api.visitsCountAPITF.root_resource_id
  path_part   = "/"
  rest_api_id = aws_api_gateway_resouce.visitsCountAPITF.id
}

resource "aws_api_gateway_method" "GET" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.myResource.id
  rest_api_id   = aws_api_gateway_rest_api.visitsCountAPITF.id
}

#Look into this
resource "aws_api_gateway_deployment" "CountDeployment" {
  rest_api_id = aws_api_gateway_rest_api.visitsCountAPITF.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.myResource.id,
      aws_api_gateway_method.GET.id,
      #aws_api_gateway_integration.example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "StageV1" {
  deployment_id = aws_api_gateway_deployment.CountDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.visitsCountAPITF.id
  stage_name    = "V1"
}

# Lambda