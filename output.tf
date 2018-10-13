output "public_ip" {
 value = "${aws_launch_configuration.testing_tr.id}"
  }
output "security_group" {
  value = "${aws_security_group.instance.id}"
}
