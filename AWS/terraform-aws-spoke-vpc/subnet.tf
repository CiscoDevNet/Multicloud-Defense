locals {
  az_map = { for idx, zone in var.zones : zone => { idx : idx } }
}

resource "aws_subnet" "subnet" {
  for_each          = local.az_map
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_bits, each.value.idx)
  availability_zone = each.key

  tags = {
    Name   = "${var.prefix}-az${each.value.idx}"
    prefix = var.prefix
  }
}

resource "aws_route_table" "rtable" {
  for_each = local.az_map
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  dynamic "route" {
    for_each = local.external_ips
    content {
      cidr_block = "${route.value}/32"
      gateway_id = aws_internet_gateway.igw.id
    }
  }
  tags = {
    Name   = "${var.prefix}-az${each.value.idx}"
    prefix = var.prefix
  }
}

resource "aws_route_table_association" "rta" {
  for_each       = local.az_map
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rtable[each.key].id
}
