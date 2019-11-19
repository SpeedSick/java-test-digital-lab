
variable "profile" {
  description = "AWS User account Profile"
}

variable "region" {
  default = "eu-central-1"
}

variable "key" {
  description = "Enter Key name"
}

variable "sub_ids" {
  default = []
}

variable "instance-ami" {
  default = "ami-0f686bcf073842e84" # AMI of Mumbai region
}

variable "instance_type" {
  default = "t3.medium"
}


variable "cluster-name" {
  description = "Cluster Name"
}

variable "server-name" {
  description = "Ec2 Server Name"
}

variable "vpc_name" {
  description = "VPC name"
}
  

provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

# VPC - Production & Staging
module "vpc" {
  source              = "./network"
  cidr                = "10.0.0.0/16"
  vpc_name            = "${var.vpc_name}"
  cluster_name        = "${module.eks.cluster-name}"
  master_subnet_cidr  = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  worker_subnet_cidr  = ["10.0.144.0/20", "10.0.160.0/20", "10.0.176.0/20"]
  public_subnet_cidr  = ["10.0.204.0/22", "10.0.208.0/22", "10.0.212.0/22"]
  private_subnet_cidr = ["10.0.228.0/22", "10.0.232.0/22", "10.0.236.0/22"]
}

module "kubernetes-server" {
  source        = "./kubernetes-server"
  instance_type = "${var.instance_type}"
  instance_ami  = "${var.instance-ami}"
  server-name   = "${var.server-name}"
  instance_key  = "${var.key}"
  vpc_id        = "${module.vpc.vpc_id}"
  k8-subnet     = "${module.vpc.public_subnet[0]}"
}

module "eks" {
  source                        = "./cluster"
  vpc_id                        = "${module.vpc.vpc_id}"
  cluster-name                  = "${var.cluster-name}"
  kubernetes-server-instance-sg = "${module.kubernetes-server.kubernetes-server-instance-sg}"
  eks_subnets                   = ["${module.vpc.master_subnet}"]
  worker_subnet                 = ["${module.vpc.worker_node_subnet}"]
  subnet_ids                    = ["${module.vpc.master_subnet}", "${module.vpc.worker_node_subnet}"]
}

# CIDR blocks
output "kubeconfig" {
  value = "${module.eks.kubeconfig}"
}

output "config_map_aws_auth" {
  value = "${module.eks.config_map_aws_auth}"
}

output "Kubenetes-server-ip" {
  value = "${module.kubernetes-server.elastic_ip}"
}

output "cluster-name" {
  value = "${module.eks.cluster-name}"
}