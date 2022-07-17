module "alb-ingress-controller" {
  source           = "../helm"
  chart            = var.chart
  name             = var.name
  repository       = var.repository
  atomic           = var.atomic
  namespace        = var.namespace
  create_namespace = var.create_namespace
  wait             = var.wait
  set              = var.set
  values = [<<EOF
serviceAccount:
  create: true
  name: ${aws_iam_role.role.name}
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.role.arn}
EOF
  ]
}
