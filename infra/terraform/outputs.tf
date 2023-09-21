output "vpc_id" {
  value = aws_vpc.mixfast_vpc.id
}

output "subnet_public_id" {
  value = aws_subnet.mixfast_subnet_public.count[id]
}

output "subnet_private_id" {
  value = aws_subnet.mixfast_subnet_private.count[id]
}