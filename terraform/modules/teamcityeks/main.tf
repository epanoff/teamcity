resource "aws_iam_role" "teamcity-cluster" {
  name = "terraform-eks-teamcity-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "teamcity-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.teamcity-cluster.name
}

resource "aws_iam_role_policy_attachment" "teamcity-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.teamcity-cluster.name
}

resource "aws_security_group" "teamcity-cluster" {
  name        = "terraform-eks-teamcity-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks"
  }
}

resource "aws_security_group_rule" "teamcity-cluster-ingress-workstation-https" {
  cidr_blocks       = ["176.57.72.47/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.teamcity-cluster.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "teamcity" {
  name     = var.cluster-name
  role_arn = aws_iam_role.teamcity-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.teamcity-cluster.id]
    subnet_ids         = var.aws_subnet_teamcity[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.teamcity-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.teamcity-cluster-AmazonEKSServicePolicy,
  ]
}