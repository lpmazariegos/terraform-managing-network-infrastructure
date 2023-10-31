resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "eip-${var.ngw}"
  }

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.dev[0].id

  tags = {
    Name = var.ngw
  }

  depends_on = [aws_internet_gateway.public]

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_rtb
  }

  depends_on = [aws_ec2_transit_gateway.tgw]

}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.dev[1].id
  route_table_id = aws_route_table.private.id
}
