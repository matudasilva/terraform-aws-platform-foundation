output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for key in sort(keys(aws_subnet.public)) : aws_subnet.public[key].id]
}

output "private_subnet_ids" {
  value = [for key in sort(keys(aws_subnet.private)) : aws_subnet.private[key].id]
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "nat_gateway_ids" {
  value = [for key in sort(keys(aws_nat_gateway.this)) : aws_nat_gateway.this[key].id]
}
