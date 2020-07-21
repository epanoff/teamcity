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
  cidr_blocks       = ["${var.workstation_ip}/32"]
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

resource "aws_iam_role" "teamcity-node" {
  name = "terraform-eks-teamcity-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "teamcity-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.teamcity-node.name
}

resource "aws_iam_role_policy_attachment" "teamcity-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.teamcity-node.name
}

resource "aws_iam_role_policy_attachment" "teamcity-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.teamcity-node.name
}

resource "aws_eks_node_group" "teamcity" {
  cluster_name    = aws_eks_cluster.teamcity.name
  node_group_name = "teamcity"
  node_role_arn   = aws_iam_role.teamcity-node.arn
  subnet_ids      = var.aws_subnet_teamcity[*].id
  instance_types  = [var.node_instance_types]

  labels = {
    nodetype = "server"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.teamcity-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.teamcity-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.teamcity-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "teamcity-agents" {
  cluster_name    = aws_eks_cluster.teamcity.name
  node_group_name = "teamcity-agents"
  node_role_arn   = aws_iam_role.teamcity-node.arn
  subnet_ids      = var.aws_subnet_teamcity_agents[*].id
  instance_types  = [var.node_instance_types]

  labels = {
    nodetype = "agent"
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.teamcity-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.teamcity-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.teamcity-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}