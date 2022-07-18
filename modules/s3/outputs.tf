output "loki_bucket_arn" {
  value = aws_s3_bucket.loki_logs.arn
}

output "loki_bucket_id" {
  value = aws_s3_bucket.loki_logs.id
}

