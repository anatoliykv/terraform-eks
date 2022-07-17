module "s3" {
  source      = "./modules/s3"
  hosted_zone = var.hosted_zone
}
