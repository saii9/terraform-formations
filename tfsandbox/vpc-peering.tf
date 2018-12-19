resource "aws_vpc_peering_connection" "tower" {
  peer_owner_id = "xxxxxxxxxxxxx"
  peer_vpc_id   = "vpc-xxxxxx"
  peer_region   = "us-east-1"
  vpc_id        = "${aws_vpc.main.id}"
  tags {
    peer-cidr = "x.x.x.x/22"
    Name      = "${format("pcx-%s-%s", var.formation, "devInfra")}"
    formation = "${var.formation}"
  }
}

resource "aws_route" "private-tower" {
  count = "${local.azones-count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block    = "${aws_vpc_peering_connection.tower.tags.peer-cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.tower.id}"
//  depends_on                = ["aws_route_table.testing"]
}

resource "aws_vpc_peering_connection" "vpn" {
  peer_owner_id = "xxxxxxxxxxxxx"
  peer_vpc_id   = "vpc-xxxxxxx"
  peer_region   = "us-east-1"
  vpc_id        = "${aws_vpc.main.id}"
  tags {
    peer-cidr = "x.x.x.x/16"
    Name      = "${format("pcx-%s-%s", var.formation, "prodVpn")}"
    formation = "${var.formation}"
  }
}

resource "aws_route" "private-vpn" {
  count = "${local.azones-count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block    = "${aws_vpc_peering_connection.vpn.tags.peer-cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.vpn.id}"
//  depends_on                = ["aws_route_table.testing"]
}
