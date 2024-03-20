resource "aws_iam_role" "ciscomcd_cloudwatch_event_role" {
  name = "${var.prefix}-inventory-role"

  tags = {
    Name   = "${var.prefix}-inventory-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ciscomcd_cloudwatch_event_policy" {
  name = "${var.prefix}-cloudwatch-event-policy"
  role = aws_iam_role.ciscomcd_cloudwatch_event_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "events:PutEvents",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:events:*:${var.controller_aws_account_number}:event-bus/default"
      ]
    }
  ]
}
EOF

}
