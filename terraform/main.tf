module "vpc" {
  source = "./modules/vpc"
  region = var.region

}

module "eks" {
  source                  = "./modules/eks"
  eks_version             = var.eks_version
  private_subnet_zone1_id = module.vpc.private_subnet_zone1_id
  private_subnet_zone2_id = module.vpc.private_subnet_zone2_id

}
