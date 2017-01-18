variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VpcID"
  default = "vpc-3957ca5c"
}

variable "subnet_id" {
  description = "SubnetID"
  default = "subnet-c8a953e3"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-1a"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "jenkins"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images."
  default = {
    us-east-1 = "ami-6df8fe7a"
    us-west-1 = "ami-1eda8d7e"
    us-west-2 = "ami-a2ca61c2"
    eu-west-1 = "ami-ba346ec9"
    eu-central-1 = "ami-e012d48f"
    ap-northeast-1 = "ami-08f7956f"
    ap-southeast-1 = "ami-f4832f97"
    ap-southeast-2 = "ami-774b7314"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "ci-challenge"
  description = "SSH key name in your AWS account for AWS instances."
}

variable "min_instance_size" {
  default = 1
  description = "Minimum number of EC2 instances."
}

variable "max_instance_size" {
  default = 2
  description = "Maximum number of EC2 instances."
}

variable "desired_instance_capacity" {
  default = 1
  description = "Desired number of EC2 instances."
}

variable "desired_service_count" {
  default = 1
  description = "Desired number of ECS services."
}

variable "s3_bucket" {
  default = "ac-jenkins"
  description = "S3 bucket where remote state and Jenkins data will be stored."
}

variable "restore_backup" {
  default = false
  description = "Whether or not to restore Jenkins backup."
}

variable "repository_url" {
  default = "default"
  description = "ECR Repository for Jenkins."
}
