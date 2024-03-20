resource "aws_subnet" "tgw_attachment" {
  vpc_id            = aws_vpc.ciscomcd_svpc.id
  count             = length(var.zones)
  cidr_block        = cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, count.index * 3)
  availability_zone = var.zones[count.index]

  tags = {
    Name   = "${var.prefix}_${var.zones[count.index]}_tgw_attachment"
    prefix = var.prefix
  }
}

resource "aws_route_table" "tgw_attachment" {
  # users must add a route in this route table for 0/0 to go to gwlbe
  vpc_id = aws_vpc.ciscomcd_svpc.id
  count  = length(var.zones)

  tags = {
    Name   = "${var.prefix}_${var.zones[count.index]}_tgw_attachment"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "tgw_attachment" {
  count          = length(var.zones)
  subnet_id      = aws_subnet.tgw_attachment[count.index].id
  route_table_id = aws_route_table.tgw_attachment[count.index].id
}

