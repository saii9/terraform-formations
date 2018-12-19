
// elastic Ips for the nat gateways
resource "aws_eip" "nat-eips" {
  count = "${local.azones-count}"
  vpc   = true
}

// Nat gate way in the public subnet of the availability zone
resource "aws_nat_gateway" "nat-gateways" {
  count         = "${local.azones-count}"
  allocation_id = "${element(aws_eip.nat-eips.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  tags {
    Name        = "ngw-${element(aws_subnet.public.*.tags.Name, count.index)}"
  }
}

resource "aws_route" "nat-gateways" {
  count = "${local.azones-count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat-gateways.*.id, count.index)}"
}
