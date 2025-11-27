terraform {
  required_version = ">= 1.3"
  backend "s3" {
    bucket  = "milind-tf-state-001"
    key     = "nodejs-monitoring-project/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
