variable "vpc_id" {
  description = "vpc_id"
}

variable "aws_subnet_teamcity" {
  description = "aws_subnet_teamcity"
  type        = list
}

variable "cluster-name" {
  default = "terraform-eks-teamcity"
  type    = string
}

variable "node_instance_types" {
  default = "t3.medium"
  type    = string
}

variable "workstation_ip" {
  description = "workstation_ip for sg"
}