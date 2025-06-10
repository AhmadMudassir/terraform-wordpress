output "vpc_id" {
  value = aws_vpc.ahmad-vpc-terra.id
}

output "public_subnet_arn" {
  value = aws_subnet.ahmad-public-subnet-terra.arn
}

output "ec2-public-ip" {
  value = aws_instance.ahmad-ec2-terra.public_ip
}

