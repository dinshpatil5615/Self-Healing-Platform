output "private_subnets" {
  value = aws_subnet.Private[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.Public[*].id
}