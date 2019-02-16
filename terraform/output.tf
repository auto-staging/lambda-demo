output "apigw_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "domain" {
  value = "${aws_route53_record.apigw-dns.fqdn}"
}

output "url" {
  value = "${aws_route53_record.apigw-dns.fqdn}/${aws_api_gateway_deployment.deployment.stage_name}"
}
