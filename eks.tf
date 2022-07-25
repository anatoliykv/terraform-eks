module "eks" {
  count                                = var.cluster_name == "" ? 0 : 1
  source                               = "./modules/eks"
  vpc_id                               = module.vpc.vpc_id
  subnets                              = module.vpc.private_subnets
  tags                                 = var.tags
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_name                         = var.cluster_name
}

