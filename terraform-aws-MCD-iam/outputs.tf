output "ciscomcd_controller_role_arn" {
  description = "this outputs the ciscomcd-controller IAM role ARN"
  value       = aws_iam_role.ciscomcd_controller_role.arn
}

output "ciscomcd_firewall_role_name" {
  description = "this outputs the name of the ciscomcd firewall role"
  value       = aws_iam_role.ciscomcd_fw_role.name
}