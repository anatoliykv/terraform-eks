module "eks" {
  source                               = "./modules/eks"
  vpc_id                               = var.vpc_id
  subnets                              = var.subnets
  tags                                 = var.tags
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
}

