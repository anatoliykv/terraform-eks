module "grafana" {
  depends_on       = [module.s3]
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
  tags             = var.tags
  values = [<<-EOF
  autoscaling:
    enabled: true
    minReplicas: 1
    maxReplicas: 1
    metrics:
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: 60
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: 60
  podDisruptionBudget:
    minAvailable: 1
  resources:
    limits:
      cpu: 300m
      memory: 256Mi
    requests:
      cpu: 200m
      memory: 128Mi
  ingress:
    enabled: true
    path: /
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
      alb.ingress.kubernetes.io/subnets: ${join(", ", var.subnets)}
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/tags: ${join(",", [for key, value in var.tags : "${key}=${value}"])}
      alb.ingress.kubernetes.io/group.name: my-team.awesome-group
      alb.ingress.kubernetes.io/success-codes: 200,302
      alb.ingress.kubernetes.io/certificate-arn: ${module.acm.cert_arn}
      alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-1-2017-01
      alb.ingress.kubernetes.io/ssl-redirect: '443'
      alb.ingress.kubernetes.io/load-balancer-attributes: routing.http2.enabled=true,access_logs.s3.enabled=true,access_logs.s3.bucket=my-elb-tf-test-bucket${var.hosted_zone},access_logs.s3.prefix=my-app
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
      - name: Loki
        type: loki
        access: proxy
        url: http://loki-stack.loki-stack.svc.cluster.local:3100
        jsonData:
          maxLines: 1000
  dashboardProviders:
    dashboardproviders.yaml:
      apiVersion: 1
      providers:
      - name: default
        orgId: 1
        folder: ''
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/default
      - name: loki
        orgId: 1
        folder: Loki
        type: file
        disableDeletion: false
        editable: true
        options:
          path: /var/lib/grafana/dashboards/loki
  dashboards:
    default:
      k8s-for-prometheus-dashboard-20211010-EN:
        gnetId: 15661
        datasource: Prometheus
      cluster-monitoring-for-kubernetes:
        gnetId: 10000
        datasource: Prometheus
      kubernetes-Deployment-Statefulset-Daemonset-metrics:
        gnetId: 8588
        datasource: Prometheus
      kubernetes-Cluster-Autoscaler:
        url: https://raw.githubusercontent.com/anatoliykv/terraform-eks/master/modules/grafana/dashboards/autoscaler_rev1.json
    loki:
      loki:
        url: https://raw.githubusercontent.com/anatoliykv/terraform-eks/master/modules/grafana/dashboards/loki-dashboard-quick-search_rev2.json
  EOF
  ]
}
