provider "aws" {
  region = var.region
}

resource "aws_vpc" "app_dev_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-vpc"
    }
  )
}
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.app_dev_vpc.id
  for_each = var.private_subnets
  availability_zone = each.value.az
  cidr_block = each.value.cidr
  map_public_ip_on_launch = false
  tags = merge(
  local.default_tags,
  {
    Name = "${local.name_prefix}-${each.key}"
  }
)
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.app_dev_vpc.id
  for_each = var.public_subnets
  availability_zone = each.value.az
  cidr_block = each.value.cidr
  map_public_ip_on_launch = true
  tags = merge(
  local.default_tags,
  {
    Name = "${local.name_prefix}-${each.key}"
  }
) 
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-nat-eip"
    }
  )
  depends_on = [aws_internet_gateway.app_dev_internet_gateway]
}


resource "aws_nat_gateway" "nat_gateway_dev" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet["public_1"].id

  tags = merge(
    local.default_tags,
    {
      Name = "${local.name_prefix}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.app_dev_internet_gateway]
}
resource "aws_internet_gateway" "app_dev_internet_gateway" {
  vpc_id = aws_vpc.app_dev_vpc.id

  tags = merge(
  local.default_tags,
  {
    Name = "${local.name_prefix}-igw"
  }
)
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.app_dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_dev.id
  }
  tags = merge(
  local.default_tags,
  {
    Name = "${local.name_prefix}-public-route-table"
  }
)
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = aws_subnet.private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_dev_internet_gateway.id
  }
  tags = merge(
  local.default_tags,
  {
    Name = "${local.name_prefix}-public-route-table"
  }
)
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}