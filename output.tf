output "rds-vpc-id" {
  value       = aws_vpc.rds-vpc.id
  description = "Environment VPC ID: "
}

output "rds-pub-subnet-id" {
  value       = aws_subnet.rds-pub-subnet.id
  description = "RDS Public Subenet: "
}