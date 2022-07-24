module "loki-stack" {
  depends_on              = [module.eks, module.vpc]
  source                  = "./modules/loki_stack"
  atomic                  = true
  chart                   = "loki-stack"
  create_namespace        = true
  name                    = "loki-stack"
  namespace               = "loki-stack"
  repository              = "https://grafana.github.io/helm-charts"
  set                     = []
  wait                    = true
  iam_role_name           = "loki-s3-bucket-role"
  bucket_arn              = module.s3.loki_bucket_arn
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn
  loki_bucket_id          = module.s3.loki_bucket_id
}
