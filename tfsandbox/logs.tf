
resource "aws_efs_file_system" "logs" {
  creation_token = "logs-${var.formation}"
  tags {
    Name = "logs-${var.formation}"
  }
}

resource "aws_efs_mount_target" "logs" {
  count = "${local.azones-count}"
  security_groups = ["${aws_security_group.efs.id}"]
  file_system_id = "${aws_efs_file_system.logs.id}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
}

//resource "aws_instance" "logServer" {
//  ami           = "ami-e3bdc199"
//  instance_type = "t2.micro"
//  subnet_id = "${aws_subnet.private.0.id}"
//  tags {
//    Name = "logServer-${var.formation}"
//  }
//}