resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.dev.id

  tags    = {
    Name  = var.igw
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block         = "10.0.0.0/8"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }

  route {
    cidr_block         = "0.0.0.0/0"
    gateway_id         = aws_internet_gateway.public.id
  }

  tags    = {
    Name  = var.public_rtb
  }

  depends_on = [aws_ec2_transit_gateway.tgw]

}

resource "aws_route_table_association" "public" {
  subnet_id       = aws_subnet.dev[0].id
  route_table_id  = aws_route_table.public.id
}