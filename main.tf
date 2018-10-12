provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "testing_tr" {
  ami = "ami-068ab34816099a0a9"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  tags {
     Name = "terraform_example"
  }
}

resource "aws_security_group" "instance" {
    name = "terraform_example_instance"

    ingress = {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  
   tags {
       Name = "example_secruty_group"
   }

}
