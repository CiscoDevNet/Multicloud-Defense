resource "aws_vpc" "ciscomcd_svpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name   = "${var.prefix}"
    prefix = var.prefix
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ciscomcd_svpc.id

  tags = {
    Name   = "${var.prefix}_igw"
    prefix = var.prefix
  }
}

# add tags to the default route table
resource "aws_default_route_table" "ciscomcd_svpc_default_rtable" {
  default_route_table_id = aws_vpc.ciscomcd_svpc.default_route_table_id

  tags = {
    Name   = "${var.prefix}_default"
    prefix = var.prefix
  }
}
