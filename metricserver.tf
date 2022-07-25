module "metricserver" {
  count            = var.cluster_name == "" ? 0 : 1
  depends_on       = [module.eks, module.vpc]
  source           = "./modules/metricserver"
  atomic           = true
  chart            = "metrics-server"
  create_namespace = true
  name             = "metrics-server"
  namespace        = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  wait             = true
  set              = []
  values           = []
}
