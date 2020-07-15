
resource "aws_vpc" "teamcity" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-teamcity-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "teamcity" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.teamcity.id

  tags = map(
    "Name", "terraform-eks-teamcity-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_internet_gateway" "teamcity" {
  vpc_id = aws_vpc.teamcity.id

  tags = {
    Name = "terraform-eks-teamcity"
  }
}

resource "aws_route_table" "teamcity" {
  vpc_id = aws_vpc.teamcity.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.teamcity.id
  }
}

resource "aws_route_table_association" "teamcity" {
  count = 2

  subnet_id      = aws_subnet.teamcity.*.id[count.index]
  route_table_id = aws_route_table.teamcity.id
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}