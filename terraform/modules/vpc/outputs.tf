output "vpc_id" {
  value = aws_vpc.teamcity.id
}

output "aws_subnet_group_teamcity" {
  value = aws_db_subnet_group.teamcity
}

output "aws_subnet_teamcity_eks" {
  value = aws_subnet.teamcity
}

output "aws_subnet_teamcity_agents_eks" {
  value = aws_subnet.teamcity-agents
}