variable "vpc_id" {
  description = "vpc_id"
}

variable "aws_subnet_teamcity" {
  description = "aws_subnet_teamcity"
  type        = list
}

variable "aws_subnet_teamcity_agents" {
  description = "aws_subnet_teamcity_agents"
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

variable "node_agents_instance_types" {
  default = "t3.medium"
  type    = string
}


variable "node_agents_scaling_group_max_size" {
  description = "node_agents_scaling_group_max_size"
}



variable "workstation_ip" {
  description = "workstation_ip for sg"
}