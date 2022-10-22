variable "region" {default = "ap-south-1"}
variable "env" {default = "dev"}
  

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket       = "terraforrm-eks-state-files"
    key          = "environment/dev/ap-south-1/iamrole/iamrole.tfstate"
    region       = "ap-south-1"
  }
}
module "iamrole" {
  source = "git::https://github.com/celigo/infra-terraform.git//modules/iam_roles/"
  
  env = var.env

}