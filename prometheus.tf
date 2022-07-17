module "prometheus" {
  source           = "./modules/prometheus"
  chart            = "kube-prometheus-stack"
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  atomic           = true
  namespace        = "prometheus-stack"
  create_namespace = true
  wait             = true
  set = [
    {
      name  = "namespaceOverride"
      value = ""
    }
  ]
  values = [<<-EOF
  alertmanager:
    enabled: true
    ingress:
      enabled: true
      paths:
      - /
      hosts:
      - ${var.alb_url}
      annotations:
        kubernetes.io/ingress.class: alb
        alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
        alb.ingress.kubernetes.io/subnets: ${join(", ", var.subnets)}
        alb.ingress.kubernetes.io/target-type: ip
  grafana:
    enabled: false
  EOF
  ]
}
