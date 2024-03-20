data "aws_region" "current" {}

output "vpc" {
  value = {
    id          = aws_vpc.vpc.id
    console_url = "https://console.aws.amazon.com/vpc/home?region=${data.aws_region.current.name}#VpcDetails:VpcId=${aws_vpc.vpc.id}"
    name        = aws_vpc.vpc.tags.Name
    cidr        = var.vpc_cidr
    igw_id      = aws_internet_gateway.igw.id
    subnets = [
      for subnet in aws_subnet.subnet :
      {
        name        = subnet.tags.Name
        id          = subnet.id
        cidr_block  = subnet.cidr_block
        console_url = "https://console.aws.amazon.com/vpc/home?region=${data.aws_region.current.name}#SubnetDetails:subnetId=${subnet.id}"
      }
    ]
  }
}

output "vms" {
  value = [
    for instance in aws_instance.vm :
    {
      public_ip   = instance.public_ip
      private_ip  = instance.private_ip
      az          = instance.availability_zone
      ssh_cmd     = "ssh ubuntu@${instance.public_ip}"
      name        = instance.tags.Name
      vpc         = aws_vpc.vpc.id
      subnet      = instance.subnet_id
      id          = instance.id
      console_url = "https://console.aws.amazon.com/ec2/v2/home?region=${data.aws_region.current.name}#InstanceDetails:instanceId=${instance.id}"
    }
  ]
}
