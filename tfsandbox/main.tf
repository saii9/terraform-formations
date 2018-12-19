provider "aws" {
  shared_credentials_file = "./aws.creds"
  region                  = "us-east-2"
  profile                 = "dev"
}

locals {
  azones = "${split(",", var.vpc["availability-zones"])}"
  azones-count = "${length(split(",", var.vpc["availability-zones"]))}"
  subnets-count = "${length(split(",", var.vpc["availability-zones"])) * 2}"
}


//data "null_data_source" "vpc" {
//  azones = "${split(",", var.vpc["availability-zones"])}"
//  azones-count = "${length(split(",", var.vpc["availability-zones"]))}"
//  subnets-count = "${length(split(",", var.vpc["availability-zones"])) * 2}"
//}
//
//resource "null_resource" "vpc" {
//  azones = "${split(",", var.vpc["availability-zones"])}"
//  azones-count = "${length(split(",", var.vpc["availability-zones"]))}"
//  subnets-count = "${length(split(",", var.vpc["availability-zones"])) * 2}"
//}


