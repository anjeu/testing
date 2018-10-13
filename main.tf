provider "aws" {
    region = "us-east-1"  
}
#-------------------------------------------------------
# EC2 instance 
#-------------------------------------------------------
resource "aws_launch_configuration" "testing_tr" {
  image_id = "ami-068ab34816099a0a9"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  
  
  lifecycle {
      create_before_destroy = true
  }

  
}
#-------------------------------------------------------
#Secutiry GROUP instace ingress
#-------------------------------------------------------
resource "aws_security_group" "instance" {
    name = "terraform_example_instance"

    ingress = {
        from_port = "${var.server_port}"
        to_port = "${var.server_port}"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }  
    lifecycle {
        create_before_destroy = true 
    }
   tags {
       Name = "example_secruty_group"
   }

}
#------------------------------------------------------
# ASG
#------------------------------------------------------
resource "aws_autoscaling_group" "example" {
    launch_configuration ="${aws_launch_configuration.testing_tr.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    min_size = 2
    max_size = 3

    tag { 
     key = "Name"
     value = "terraform-asg-example"
     propagate_at_launch = true 

    }
}
#-------------------------------------------------------------
#ELB
#-------------------------------------------------------------
resource "aws_elb" "example_elb" {
  name = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_securuty_group.elb.id}"]

    listener = {

    lb_port = 80 
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
}
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }

}

#-------------------------------------------------------
#Secutiry GROUP ELB ingress
#-------------------------------------------------------
resource "aws_security_group" "elb" {
    name = "terraform-example-elb"

    ingress {
      from_port = "${var.elb_port}" 
      to_port ="${var.elb_port}"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

            }
    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

