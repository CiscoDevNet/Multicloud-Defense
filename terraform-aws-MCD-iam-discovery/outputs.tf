output "ciscomcd_controller_role_arn" {
  description = "this outputs the ciscomcd-controller IAM role ARN"
  value       = aws_iam_role.ciscomcd_controller_role.arn
}
