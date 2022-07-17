module "acm" {
  source      = "./modules/certificate_manager"
  domain_name = var.hosted_zone
  subject_alternative_names = [
    "grafana.${var.hosted_zone}",
    "kube-prometheus-stack.${var.hosted_zone}"
  ]
  tags        = var.tags
  hosted_zone = var.hosted_zone
}
