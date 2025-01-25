terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }

}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
#   endpoints {
#     apigateway     = "http://localhost:4566"
#     apigatewayv2   = "http://localhost:4566"
#     cloudformation = "http://localhost:4566"
#     cloudwatch     = "http://localhost:4566"
#     dynamodb       = "http://localhost:4566"
#     ec2            = "http://localhost:4566"
#     es             = "http://localhost:4566"
#     elasticache    = "http://localhost:4566"
#     firehose       = "http://localhost:4566"
#     iam            = "http://localhost:4566"
#     kinesis        = "http://localhost:4566"
#     lambda         = "http://localhost:4566"
#     rds            = "http://localhost:4566"
#     redshift       = "http://localhost:4566"
#     route53        = "http://localhost:4566"
#     s3             = "http://s3.localhost.localstack.cloud:4566"
#     secretsmanager = "http://localhost:4566"
#     ses            = "http://localhost:4566"
#     sns            = "http://localhost:4566"
#     sqs            = "http://localhost:4566"
#     ssm            = "http://localhost:4566"
#     stepfunctions  = "http://localhost:4566"
#     sts            = "http://localhost:4566"
#   }

    endpoints {
        ec2            = "http://localhost:4566"
    }
}

resource "aws_instance" "myserver" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  count = 100

  tags = {
    Name = "Server${count.index + 1}",
  }
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy
resource "aws_iam_role_policy" "ec2_policy" {
  name   = "ec2-instance-policy"
  role   = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "s3:ListBucket",
        Resource = "*"
      }
    ]
  })
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}