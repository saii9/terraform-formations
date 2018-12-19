
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc["cidr"]}"
  tags {
    Name = "vpc-${var.formation}"
    formation = "${var.formation}"
  }
}

resource "aws_subnet" "private" {
  count             = "${local.azones-count}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${format("%s%s", var.aws_region, element(local.azones, count.index))}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 2, count.index*2)}"
  tags {
    Name = "${format("sn-%s-%s-%s", var.formation, "private", element(local.azones, count.index))}"
    formation = "${var.formation}"
  }
}

resource "aws_subnet" "public" {
  count             = "${local.azones-count}"
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${format("%s%s", var.aws_region, element(local.azones, count.index))}"
  cidr_block        = "${cidrsubnet(aws_vpc.main.cidr_block, 2, count.index*2+1)}"
  tags {
    Name = "${format("sn-%s-%s-%s", var.formation, "public", element(local.azones, count.index))}"
    formation = "${var.formation}"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"
  tags {
    Name = "rtb-${var.formation}-public"
  }
}

resource "aws_route_table" "private" {
  count = "${local.azones-count}"
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "rtb-${element(aws_subnet.private.*.tags.Name, count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count = "${local.azones-count}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count = "${local.azones-count}"
  route_table_id = "${aws_default_route_table.main.id}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name = "igw-${var.formation}"
    formation = "${var.formation}"
  }
}

resource "aws_route" "igw" {
  count = "${local.azones-count}"
  route_table_id = "${aws_default_route_table.main.id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

resource "aws_default_network_acl" "public" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name = "nacl-${var.formation}-public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name = "nacl-${var.formation}-private"
  }
}
