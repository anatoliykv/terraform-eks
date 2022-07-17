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
  values = [<<EOF
grafana:
  enabled: false
  ingress:
    enabled: true
EOF
  ]
}
