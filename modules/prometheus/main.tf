module "prometheus" {
  source           = "../helm"
  chart            = var.chart
  name             = var.name
  repository       = var.repository
  set              = var.set
  values           = var.values
  atomic           = var.atomic
  namespace        = var.namespace
  create_namespace = var.create_namespace
  wait             = var.wait
}
