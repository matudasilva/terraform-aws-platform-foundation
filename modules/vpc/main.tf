locals {
  availability_zone_map = {
    for index, availability_zone in var.availability_zones :
    tostring(index) => {
      az                  = availability_zone
      public_subnet_cidr  = var.public_subnet_cidrs[index]
      private_subnet_cidr = var.private_subnet_cidrs[index]
      suffix              = index + 1
    }
  }

  nat_gateway_map = var.enable_nat_gateway ? (
    var.single_nat_gateway ? {
      "0" = local.availability_zone_map["0"]
    } : local.availability_zone_map
  ) : {}
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-vpc"
  })
}

resource "aws_subnet" "public" {
  for_each = local.availability_zone_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public_subnet_cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-public-${each.value.suffix}"
  })
}

resource "aws_subnet" "private" {
  for_each = local.availability_zone_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.private_subnet_cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-private-${each.value.suffix}"
  })
}

resource "aws_internet_gateway" "this" {
  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-igw"
  })
}

resource "aws_internet_gateway_attachment" "this" {
  vpc_id              = aws_vpc.this.id
  internet_gateway_id = aws_internet_gateway.this.id
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_map

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-nat-eip-${each.value.suffix}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each = local.nat_gateway_map

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-nat-${each.value.suffix}"
  })

  depends_on = [aws_internet_gateway_attachment.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-public-rt"
  })
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = local.availability_zone_map

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = local.availability_zone_map

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-private-rt-${each.value.suffix}"
  })
}

resource "aws_route" "private_nat_gateway" {
  for_each = var.enable_nat_gateway ? local.availability_zone_map : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.single_nat_gateway ? aws_nat_gateway.this["0"].id : aws_nat_gateway.this[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = local.availability_zone_map

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for route_table in aws_route_table.private : route_table.id]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["environment"]}-s3-endpoint"
  })
}
