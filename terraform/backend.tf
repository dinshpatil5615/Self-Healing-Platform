terraform {
  backend "s3" {
    bucket = "self-healing-platform-key-13-01"
    key    = "self-healing/terraform.tfstate"
    region = "ap-south-1"
  }
}