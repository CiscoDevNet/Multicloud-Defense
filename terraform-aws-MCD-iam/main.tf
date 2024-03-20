# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "3.28.0"
#     }
#   }
# }

# provider "aws" {
#   region  = "us-east-1"
#   profile = "demo"
# }

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}