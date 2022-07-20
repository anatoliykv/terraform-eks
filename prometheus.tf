module "prometheus" {
  depends_on       = [module.s3, module.alb-ingress-controller]
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
      - /*
      hosts:
      - kube-prometheus-stack.${var.hosted_zone}
      annotations:
        kubernetes.io/ingress.class: alb
        alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
        alb.ingress.kubernetes.io/scheme: internet-facing
        alb.ingress.kubernetes.io/subnets: ${join(", ", var.subnets)}
        alb.ingress.kubernetes.io/target-type: ip
        alb.ingress.kubernetes.io/tags: ${join(",", [for key, value in var.tags : "${key}=${value}"])}
        alb.ingress.kubernetes.io/group.name: my-team.awesome-group
        alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
        alb.ingress.kubernetes.io/certificate-arn: ${module.acm.cert_arn}
        alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-1-2017-01
        alb.ingress.kubernetes.io/ssl-redirect: '443'
        alb.ingress.kubernetes.io/load-balancer-attributes: routing.http2.enabled=true,access_logs.s3.enabled=true,access_logs.s3.bucket=my-elb-tf-test-bucket${var.hosted_zone},access_logs.s3.prefix=my-app
  grafana:
    enabled: false
  EOF
  ]
  hosted_zone = var.hosted_zone
}
