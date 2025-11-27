variable "region" { default = "us-east-1" }
variable "project" { default = "nodejs-monitoring-project" }
variable "vpc_cidr_1" { default = "10.0.0.0/16" }
variable "vpc_cidr_2" { default = "10.10.0.0/16" }
variable "public_azs" { default = ["us-east-1a", "us-east-1b"] }
variable "node_instance_type" { default = "t3.medium" }
variable "key_name" { default = "milind-key" }
variable "account_id" { default = "396913715368" }
