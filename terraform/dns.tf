resource "aws_route53_record" "apigw-dns" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.repository}-${var.branch}.janrtr.space"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.regional.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.regional.regional_zone_id}"
    evaluate_target_health = true
  }
}
