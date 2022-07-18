module "loki" {
  source           = "../helm"
  atomic           = var.atomic
  chart            = var.chart
  create_namespace = var.create_namespace
  name             = var.name
  namespace        = var.namespace
  repository       = var.repository
  wait             = var.wait
  set              = []
  values = [<<-EOF
loki:
  enabled: true
  serviceAccount:
    create: true
    name: ${var.iam_role_name}
    annotations:
      eks.amazonaws.com/role-arn: ${aws_iam_role.role.arn}
  config:
    auth_enabled: false
    ingester:
      chunk_idle_period: 3m
      chunk_block_size: 262144
      chunk_retain_period: 1m
      max_transfer_retries: 0
      lifecycler:
        ring:
          kvstore:
            store: inmemory
          replication_factor: 1
    limits_config:
      enforce_metric_name: false
      reject_old_samples: true
      reject_old_samples_max_age: 168h
    schema_config:
      configs:
      - from: 2020-07-01
        store: boltdb-shipper
        object_store: aws
        schema: v11
        index:
          prefix: loki_index_
          period: 24h
    server:
      http_listen_port: 3100
    storage_config:
      aws:
        s3: s3://us-east-1/${var.loki_bucket_id}
      boltdb_shipper:
        active_index_directory: /data/loki/index
        shared_store: s3
        cache_location: /data/loki/boltdb-cache
    chunk_store_config:
      max_look_back_period: 0s
    table_manager:
      retention_deletes_enabled: false
      retention_period: 0s
EOF
  ]
}

data "aws_region" "current" {}