data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "my-elb-tf-test-bucket${var.hosted_zone}"
}

resource "aws_s3_bucket_acl" "elb_logs_acl" {
  bucket = aws_s3_bucket.elb_logs.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "allow_elb_logging" {
  bucket = aws_s3_bucket.elb_logs.id
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-elb-tf-test-bucket${var.hosted_zone}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}
