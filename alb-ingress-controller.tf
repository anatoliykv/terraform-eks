module "alb-ingress-controller" {
  depends_on              = [module.eks, module.vpc]
  source                  = "./modules/alb-ingress-controller"
  atomic                  = true
  chart                   = "aws-load-balancer-controller"
  create_namespace        = false
  name                    = "aws-load-balancer-controller"
  namespace               = "kube-system"
  repository              = "https://aws.github.io/eks-charts"
  wait                    = true
  iam_role_name           = "${module.eks.cluster_id}-alb-ingress-controller-role"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn
  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_id
    }
  ]
}
