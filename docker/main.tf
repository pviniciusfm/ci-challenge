provider "aws" {
  region = "us-east-1"
  profile= "avenuecode"
}

variable "jenkins_image_name" {
  default = "avenuecode/jenkins"
  description = "Jenkins image name."
}

resource "aws_ecr_repository" "default" {
  name = "${var.jenkins_image_name}"
  provisioner "local-exec" {
    command = "./deploy-image.sh ${self.repository_url} ${var.jenkins_image_name}"
  }
}
