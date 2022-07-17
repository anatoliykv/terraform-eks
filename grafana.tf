module "grafana" {
  source           = "./modules/grafana"
  atomic           = true
  chart            = "grafana"
  create_namespace = true
  name             = "grafana"
  namespace        = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  wait             = true
  set              = []
  hosted_zone      = var.hosted_zone
  values = [<<-EOF
  ingress:
    enabled: true
    path: /
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
      alb.ingress.kubernetes.io/subnets: ${join(", ", var.subnets)}
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/tags: ${join(",", [for key, value in var.tags : "${key}=${value}"])}
      alb.ingress.kubernetes.io/group.name: my-team.awesome-group
      alb.ingress.kubernetes.io/success-codes: 200,302
    hosts:
    - grafana.${var.hosted_zone}
  plugins:
  - digrich-bubblechart-panel
  - grafana-clock-panel
  - grafana-singlestat-panel
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
      - name: Prometheus
        type: prometheus
        url: http://kube-prometheus-stack-prometheus.prometheus-stack.svc.cluster.local:9090
        access: proxy
        isDefault: true
  dashboards:
    default:
      prometheus-stats:
        gnetId: 2
        revision: 2
        datasource: Prometheus
      kubernetes-cluster:
        gnetId: 6417
        datasource: Prometheus
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: 'default'
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/default
  EOF
  ]
}
