resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name   = "${var.prefix}-vpc"
    prefix = var.prefix
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.prefix}-igw"
    prefix = var.prefix
  }
}

# add tags to the default route table
resource "aws_default_route_table" "vpc_default_rtable" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name   = "${var.prefix}-default-rtable"
    prefix = var.prefix
  }
}
