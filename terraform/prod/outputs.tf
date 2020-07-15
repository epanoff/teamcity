output "db_host" {
  value = module.postgres.db_host
}

output "db_port" {
  value = module.postgres.db_port
}

output "db_user_id" {
  value = module.postgres.db_user_id
}

output "db_password" {
  value = module.postgres.db_password
}

output "config_map_aws_auth" {
  value = module.teamcityeks.config_map_aws_auth
}

output "kubeconfig" {
  value = module.teamcityeks.kubeconfig
}