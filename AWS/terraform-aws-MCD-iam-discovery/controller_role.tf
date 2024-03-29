
# create a role that will be used by ciscomcd controller with permissions
resource "aws_iam_role" "ciscomcd_controller_role" {
  name = "${var.prefix}controllerrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.controller_aws_account_number}:root"
        ]
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.ExternalId}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ciscomcd_controller_policy" {
  name = "${var.prefix}_controller_policy"
  role = aws_iam_role.ciscomcd_controller_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
          "ec2:Describe*",
          "acm:Describe*",
          "elasticloadbalancing:Describe*",
          "apigateway:GET",
          "acm:Get*",
          "acm:List*",
          "ec2:Get*"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.ciscomcd_s3_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_iam_role.ciscomcd_controller_role.arn}"
      ]
    }
  ]
}

EOF
}
