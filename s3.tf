module "s3" {
  count       = var.cluster_name == "" ? 0 : 1
  source      = "./modules/s3"
  hosted_zone = var.hosted_zone
}
