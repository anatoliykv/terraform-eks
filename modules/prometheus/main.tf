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

data "kubernetes_ingress_v1" "example" {
  depends_on = [module.prometheus]
  metadata {
    name      = "kube-prometheus-stack-alertmanager"
    namespace = var.namespace
  }
}

data "aws_route53_zone" "selected" {
  name = "${var.hosted_zone}."
}

resource "aws_route53_record" "grafana_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_ingress_v1.example.status.0.load_balancer.0.ingress.0.hostname]
}
