output "vpc_id" { 
    value = aws_vpc.teamcity.id
}

output "aws_subnet_teamcity" { 
    value = aws_subnet.teamcity
}