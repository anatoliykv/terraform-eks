resource "helm_release" "this" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.namespace
  atomic           = var.atomic
  create_namespace = var.create_namespace
  wait             = var.wait
  dynamic "set" {
    for_each = var.set
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    content {
      type  = "string"
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }
  values = var.values
}
