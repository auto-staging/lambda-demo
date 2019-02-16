data "aws_caller_identity" "current" {}

data "aws_route53_zone" "primary" {
  name = "janrtr.space"
}

data "aws_acm_certificate" "cert" {
  domain   = "*.janrtr.space"
  statuses = ["ISSUED"]
}
