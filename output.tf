output "public_ip" {
  value = "${aws_instance.testing_tr.private_ip}"
  }
output "security_group" {
  value = "${aws_security_group.instance.id}"
}
