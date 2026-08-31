output "internet_gateway" {
  value = aws_internet_gateway.this.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_id" {
  value = [for key, subnet in var.subnets :
    aws_subnet.this[key].id
    if subnet.type == "public"]
}

output "private_subnet_id" {
    value = [for key, subnet in var.subnets :
    aws_subnet.this[key].id
    if subnet.type == "private"]
}