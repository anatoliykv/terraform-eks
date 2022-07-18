resource "aws_iam_role" "role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.oidc_assume_role_policy.json
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name  = var.iam_role_name
  role  = aws_iam_role.role.name
  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        Effect : "Allow",
        Action : [
          "s3:PutObject",
          "s3:GetObjectAcl",
          "s3:GetObject",
          "s3:PutObjectRetention",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ],
        Resource : [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}
data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.iam_role_name}"]
    }
    principals {
      identifiers = [var.oidc_provider_arn]
      type        = "Federated"
    }
  }
}
