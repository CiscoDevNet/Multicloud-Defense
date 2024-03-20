resource "aws_route53_resolver_query_log_config" "ciscomcd_route53_query_logging" {
  name            = "${var.prefix}-route53-logging"
  destination_arn = aws_s3_bucket.ciscomcd_s3_bucket.arn
}