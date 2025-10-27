module "vpc" {
  source = "./modules/vpc"
  region = var.region

}

module "eks" {
  source = "./modules/eks"
  region = var.region
  eks_version = var.eks_version

}