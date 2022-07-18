resource "aws_s3_bucket" "loki_logs" {
  bucket = "loki-logs-${var.hosted_zone}"
}
