resource "aws_subnet" "mgmt" {
  vpc_id            = aws_vpc.ciscomcd_svpc.id
  count             = length(var.zones)
  cidr_block        = cidrsubnet(var.vpc_cidr, var.vpc_subnet_bits, (count.index * 3) + 2)
  availability_zone = var.zones[count.index]

  tags = {
    Name   = "${var.prefix}_${var.zones[count.index]}_mgmt"
    prefix = var.prefix
  }
}

resource "aws_route_table" "mgmt" {
  vpc_id = aws_vpc.ciscomcd_svpc.id
  count  = length(var.zones)

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name   = "${var.prefix}_${var.zones[count.index]}_mgmt"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "mgmt" {
  count          = length(var.zones)
  subnet_id      = aws_subnet.mgmt[count.index].id
  route_table_id = aws_route_table.mgmt[count.index].id
}


resource "aws_security_group" "mgmt" {
  name   = "${var.prefix}_mgmt"
  vpc_id = aws_vpc.ciscomcd_svpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name   = "${var.prefix}_mgmt"
    prefix = var.prefix
  }
}
