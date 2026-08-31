resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    tags = {
        Name = "${local.tag_prefix}"
    }
}
resource "aws_subnet" "this" {
  for_each = var.subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block
  map_public_ip_on_launch = each.value.type == "public" ? true : false
  tags = {
    Name = "${local.tag_prefix}${each.key}"
    Type = each.value.type
  }
}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${local.tag_prefix}internet-gateway"
  }
}

resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    Name = "${local.tag_prefix}nat-eip"
  }

}
resource "aws_nat_gateway" "this" {
    subnet_id = aws_subnet.this[keys(local.public_subnets)[0]].id
    allocation_id = aws_eip.this.id
    tags = {
      Name = "${local.tag_prefix}nat-gateway"
    }
    depends_on = [ aws_internet_gateway.this ]
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name= "${local.tag_prefix}public-route"
  }
}

resource "aws_route_table_association" "this" {
  route_table_id = aws_route_table.this.id
  for_each = local.public_subnets
  subnet_id = aws_subnet.this[each.key].id
  depends_on = [ aws_route_table.this ]
  
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "${local.tag_prefix}private-route"
  }
  depends_on = [ aws_nat_gateway.this ]
}

