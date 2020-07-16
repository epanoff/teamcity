output "db_host" {
  value = "${aws_db_instance.teamcity-cluster.address}"
}

output "db_port" {
  value = "${aws_db_instance.teamcity-cluster.port}"
}

output "db_name" {
  value = "${aws_db_instance.teamcity-cluster.name}"
}

output "db_user_id" {
  value = "${aws_db_instance.teamcity-cluster.username}"
}

output "db_password" {
  value = "${aws_db_instance.teamcity-cluster.password}"
}
 