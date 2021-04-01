
output "vpc_id" {
  value       = aws_vpc.david.id
  description = "The ID of the VPC"
}

// output "aws_security_group.david-IALB" {
//   value       = aws_security_group.david-IALB.id
//   description = "IALB security group."
// }

// output "db_security_group" {
//   value = aws_security_group.mtc_sg["rds"].id
// }

// output "aws_security_group.david-ALB" {
//   value       = aws_security_group.david-ALB.id
//   description = "The ID of the VPC"

// }

// output "aws_subnet.public-subnets-1" {
//   value       = aws_subnet.public-subnets[0].id
//   description = "The first public subnet"
// }


// output "aws_subnet.public-subnets-2" {
//   value       = aws_subnet.public-subnets[1].id
//   description = "The first public subnet"
// }

