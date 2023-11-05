resource "aws_vpc" "mixfast_vpc" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames

  tags = var.tags
}

resource "aws_subnet" "mixfast_subnet_private" {
  vpc_id                  = aws_vpc.mixfast_vpc.id
  count                   = length(var.privatesCIDRblock)
  cidr_block              = element(var.privatesCIDRblock, count.index)
  availability_zone       = element(var.availabilityZone, count.index)
  map_public_ip_on_launch = false

  tags = var.tags
}

resource "aws_subnet" "mixfast_subnet_public" {
  vpc_id                  = aws_vpc.mixfast_vpc.id
  count                   = length(var.publicsCIDRblock)
  cidr_block              = element(var.publicsCIDRblock, count.index)
  availability_zone       = element(var.availabilityZone, count.index)
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_internet_gateway" "mixfast_internet_gateway" {
  vpc_id = aws_vpc.mixfast_vpc.id

  tags = var.tags
}

resource "aws_route_table" "mixfast_route_table" {
  vpc_id = aws_vpc.mixfast_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mixfast_internet_gateway.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "mixfast_route_table_association_public" {
  count          = length(var.publicsCIDRblock)
  subnet_id      = element(aws_subnet.mixfast_subnet_public[*].id, count.index)
  route_table_id = aws_route_table.mixfast_route_table.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.mixfast_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.mixfast_route_table.id]
  policy            = data.aws_iam_policy_document.s3_ecr_access.json
}

resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
  vpc_id              = aws_vpc.mixfast_vpc.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["sg-0a5f0bcef25218c7c"]
  subnet_ids          = aws_subnet.mixfast_subnet_private.*.id

}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {
  vpc_id              = aws_vpc.mixfast_vpc.id
  private_dns_enabled = true
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = ["sg-0a5f0bcef25218c7c"]
  subnet_ids          = aws_subnet.mixfast_subnet_private.*.id
}

resource "aws_vpc_endpoint" "ecs-agent" {
  vpc_id              = aws_vpc.mixfast_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecs-agent"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["sg-0a5f0bcef25218c7c"]
  subnet_ids          = aws_subnet.mixfast_subnet_private.*.id
}
resource "aws_vpc_endpoint" "ecs-telemetry" {
  vpc_id              = aws_vpc.mixfast_vpc.id
  service_name        = "com.amazonaws.${var.region}.ecs-telemetry"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  security_group_ids  = ["sg-0a5f0bcef25218c7c"]
  subnet_ids          = aws_subnet.mixfast_subnet_private.*.id
}