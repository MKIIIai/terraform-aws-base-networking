resource "aws_eip" "nat" {
  for_each = local.include_nat_gateways == "yes" ? local.az_map : {}

  domain = "vpc"

  tags = {
    Name                 = "eip-nat-${var.component}-${var.deployment_identifier}-${element(var.availability_zones, count.index)}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}

resource "aws_nat_gateway" "base" {
  for_each = local.include_nat_gateways == "yes" ? local.az_map : {}

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  depends_on = [
    aws_internet_gateway.base_igw
  ]

  tags = {
    Name                 = "nat-${var.component}-${var.deployment_identifier}-${element(var.availability_zones, count.index)}"
    Component            = var.component
    DeploymentIdentifier = var.deployment_identifier
  }
}
