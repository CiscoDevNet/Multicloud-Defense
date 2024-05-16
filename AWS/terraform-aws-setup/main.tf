terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    ciscomcd = {
      source = "CiscoDevNet/ciscomcd"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
