
resource "aws_security_group" "ec2" {
  name        = "sgroup-ec2-${var.formation}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags { Name = "sgroup-ec2-${var.formation}" }
  ingress {
    protocol        = "tcp"
    from_port       = 8443
    to_port         = 8443
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpn" {
  name        = "sgroup-vpn-${var.formation}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags { Name = "sgroup-vpn-${var.formation}" }
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks     = ["172.31.0.0/16"]
  }
  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks     = ["172.25.4.0/22"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs" {
  name        = "sgroup-efs-${var.formation}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags { Name = "sgroup-efs-${var.formation}" }
  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    security_groups = ["${aws_security_group.ec2.id}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redis" {
  name        = "sgroup-redis-${var.formation}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"
  tags {  Name = "sgroup-redis-${var.formation}" }
  ingress {
    protocol    = "tcp"
    from_port   = 6379
    to_port     = 6379
    security_groups = ["${aws_security_group.ec2.id}"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds" {
  name        = "sgroup-rds-${var.formation}"
  description = "Allow traffic to 3306 mysql port"
  vpc_id      = "${aws_vpc.main.id}"
  tags { Name = "sgroup-rds-${var.formation}" }
  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    security_groups = ["${aws_security_group.ec2.id}"]
    cidr_blocks     = ["172.31.0.0/16", "172.25.4.0/22"]
  }
}

resource "aws_security_group" "nginx" {
  name        = "sgroup-nginx-${var.formation}"
  description = "Nginx ingress and egress rules"
  vpc_id      = "${aws_vpc.main.id}"
  tags { Name = "sgroup-nginx-${var.formation}" }
  ingress {
      protocol	    = "tcp"
      description	= "VPC/DEV Ansible Tower/VPN"
      from_port	    = 443
      to_port		= 443
      cidr_blocks	= [ "172.25.32.0/22",
                      "172.25.4.11/32",
                      "172.31.0.0/16"]
  }
  ingress {
      protocol	    = "tcp"
      description	= "VPC/DEV Ansible Tower/VPN"
      from_port	    = 80
      to_port		= 80
      cidr_blocks	= [ "172.25.32.0/22",
                      "172.25.4.11/32",
                      "172.31.0.0/16"]
  }
  ingress {
      protocol	    = "tcp"
      description	= "Incapsula HTTPS"
      from_port	    = 443
      to_port		= 443
      cidr_blocks	= ["185.11.124.0/22",
                      "192.230.64.0/18",
                      "198.143.32.0/19",
                      "199.83.128.0/21",
                      "45.223.0.0/16",
                      "45.60.0.0/16",
                      "45.64.64.0/22",
                      "103.28.248.0/22",
                      "107.154.0.0/16",
                      "149.126.72.0/21"]
  }
  ingress {
      protocol      = "tcp"
      description   = "Incapsula HTTP"
      from_port     = 80
      to_port       = 80
      cidr_blocks   = ["185.11.124.0/22",
                      "192.230.64.0/18",
                      "198.143.32.0/19",
                      "199.83.128.0/21",
                      "45.223.0.0/16",
                      "45.60.0.0/16",
                      "45.64.64.0/22",
                      "103.28.248.0/22",
                      "107.154.0.0/16",
                      "149.126.72.0/21"]
  }
}
