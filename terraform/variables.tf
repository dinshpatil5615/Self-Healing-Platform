variable "cluster_name" {
  default = "Self-healing-eks"
}

variable "region" {
  default = "ap-south-1"
}

variable "key_name" {
  default = "jenkins_key_pair"
}

variable "instance_type" { default = "t3.micro" }