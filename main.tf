provider "aws" {
  region  = "us-east-1"
  profile = "avenuecode"
}

data "terraform_remote_state" "tfstate" {
  backend = "s3"

  config {
    profile = "avenuecode"
    bucket  = "ac-terraform"
    key     = "jenkins/terraform.tfstate"
    region  = "us-east-1"
  }
}

resource "aws_security_group" "sg_jenkins" {
  name        = "sg_${var.ecs_cluster_name}"
  description = "Allows all traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 50000
    to_port   = 50000
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_eip" "default" {
  instance = "${aws_instance.docker_host.id}"
  vpc      = true
}

data "template_file" "user_data" {
  template = "${file("templates/user_data.tpl")}"

  vars {
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_iam_role" "host_role_jenkins" {
  name               = "host_role_${var.ecs_cluster_name}"
  assume_role_policy = "${file("policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "instance_role_policy_jenkins" {
  name   = "instance_role_policy_${var.ecs_cluster_name}"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.host_role_jenkins.id}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name  = "iam_instance_profile_${var.ecs_cluster_name}"
  path  = "/"
  roles = ["${aws_iam_role.host_role_jenkins.name}"]
}

resource "aws_instance" "docker_host" {
  ami                         = "${var.amis[var.region]}"
  instance_type               = "${var.instance_type}"
  vpc_security_group_ids      = ["${aws_security_group.sg_jenkins.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.iam_instance_profile.name}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  user_data                   = "${data.template_file.user_data.rendered}"

  tags {
    Name = "ci-challenge"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z28OXLF42SHD6B"
  name    = "*.ci.challenge.avenuecode.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.docker_host.public_ip}"]
}
