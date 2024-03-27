locals {
  user_data = <<EOF
#! /bin/bash
curl -o /tmp/setup.sh https://raw.githubusercontent.com/maskiran/sample-web-app/main/ubuntu/setup_app.sh
bash /tmp/setup.sh &> /tmp/setup.log
EOF
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "vm" {
  # vms_list  [ {az_name: us-east1-a, vm_name: vm_az0_vm0}, ...]
  # convert this to a map of vm names, so i can dynamically change number of vms per zone later on
  for_each                    = { for vm_details in local.vms_list : vm_details.vm_name => vm_details }
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = each.value.az_name
  subnet_id                   = aws_subnet.subnet[each.value.az_name].id
  vpc_security_group_ids      = [aws_security_group.security_group.id]
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name   = each.key
    prefix = var.prefix
  }
  volume_tags = {
    Name   = each.key
    prefix = var.prefix
  }

  user_data = local.user_data
}
