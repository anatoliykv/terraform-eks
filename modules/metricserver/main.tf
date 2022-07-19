module "metricserver" {
  source           = "../helm"
  atomic           = var.atomic
  chart            = var.chart
  create_namespace = var.create_namespace
  name             = var.name
  namespace        = var.namespace
  repository       = var.repository
  values           = var.values
  wait             = var.wait
}
