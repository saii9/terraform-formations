data "template_file" "nginx-user-data" {
  template = "${file("nginx-user-data.sh")}"
  vars {
    nginx= "${var.nginx}"
  }
}

# Create a web server
resource "aws_instance" "nginx" {

  user_data = "${data.template_file.nginx-user-data.rendered}"
}