module "grafana" {
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

data "kubernetes_ingress_v1" "grafana_ingress" {
  depends_on = [module.grafana]
  metadata {
    name      = var.name
    namespace = var.namespace
  }
}

data "aws_route53_zone" "selected" {
  name = "${var.hosted_zone}."
}

resource "aws_route53_record" "grafana_record" {
  depends_on = [data.kubernetes_ingress_v1.grafana_ingress]
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_ingress_v1.grafana_ingress.status.0.load_balancer.0.ingress.0.hostname]
}
