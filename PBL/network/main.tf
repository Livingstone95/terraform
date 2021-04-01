#--- networking/main.tf--- 
data "aws_availability_zones" "available-zones" {
  state = "available"
}


resource "aws_vpc" "david" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = {
    Name = "david-vpc"
  }
}


resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available-zones.names
  result_count = var.max_subnets
}


resource "aws_subnet" "private-subnets" {
  vpc_id                  = aws_vpc.david.id
  count                   = var.private_sn_count
  cidr_block              = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "PrivateSubnet"
  }

}

resource "aws_subnet" "public-subnets" {
  vpc_id                  = aws_vpc.david.id
  count                   = var.public_sn_count
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "PublicSubnet"
  }

}

resource "aws_internet_gateway" "david-ig" {
  vpc_id = aws_vpc.david.id
  tags = {
    Name = "david-ig"
  }
}


resource "aws_eip" "david-eip" {
  count      = var.public_sn_count
  vpc        = true
  depends_on = [aws_internet_gateway.david-ig]

  tags = {
    Name = "david-eip"
  }
}

resource "aws_nat_gateway" "david-ng" {
  count         = var.public_sn_count
  allocation_id = aws_eip.david-eip[count.index].id
  subnet_id     = element(aws_subnet.public-subnets.*.id, 0)
  depends_on    = [aws_internet_gateway.david-ig]

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_route_table" "private-rtb" {
  count  = var.public_sn_count
  vpc_id = aws_vpc.david.id

  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route" "private-rtb-route" {
  count                  = var.public_sn_count
  route_table_id         = aws_route_table.private-rtb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.david-ng[count.index].id
}

resource "aws_route_table_association" "private-subnets-assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rtb[count.index].id
}


resource "aws_route_table" "public-rtb" {
  count  = var.public_sn_count
  vpc_id = aws_vpc.david.id


  tags = {
    Name = "private-rtb"
  }
}

resource "aws_route" "public-rtb-route" {
  count                  = var.public_sn_count
  route_table_id         = aws_route_table.public-rtb[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.david-ig.id
}

resource "aws_route_table_association" "public-subnets-assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.public-rtb[count.index].id
}


resource "aws_security_group" "david-sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.david.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}