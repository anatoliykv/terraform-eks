module "acm" {
  source                    = "terraform-aws-modules/acm/aws"
  version                   = "~> 4.0"
  domain_name               = var.domain_name
  zone_id                   = data.aws_route53_zone.selected.zone_id
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation       = true
  create_route53_records    = true
  validation_method         = "DNS"
  tags                      = var.tags
}

data "aws_route53_zone" "selected" {
  name = "${var.hosted_zone}."
}
