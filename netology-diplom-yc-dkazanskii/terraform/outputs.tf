# outputs
# nginx
output "internal_ip_address_nginx_yandex_cloud" {
  value = yandex_compute_instance.nginx.network_interface.0.ip_address
}
output "external_ip_address_nginx_yandex_cloud" {
  value = yandex_compute_instance.nginx.network_interface.0.nat_ip_address
}

#db01
output "internal_ip_address_db01_yandex_cloud" {
  value = yandex_compute_instance.db01.network_interface.0.ip_address
}
output "external_ip_address_db01_yandex_cloud" {
  value = yandex_compute_instance.db01.network_interface.0.nat_ip_address
}

#db02
output "internal_ip_address_db02_yandex_cloud" {
  value = yandex_compute_instance.db02.network_interface.0.ip_address
}
output "external_ip_address_db02_yandex_cloud" {
  value = yandex_compute_instance.db02.network_interface.0.nat_ip_address
}

# wordpresss
output "internal_ip_address_app_yandex_cloud" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}
output "external_ip_address_app_yandex_cloud" {
  value = yandex_compute_instance.app.network_interface.0.nat_ip_address
}

# gitlab
output "internal_ip_address_gitlab_yandex_cloud" {
  value = yandex_compute_instance.gitlab.network_interface.0.ip_address
}
output "external_ip_address_gitlab_yandex_cloud" {
  value = yandex_compute_instance.gitlab.network_interface.0.nat_ip_address
}

# runner
output "internal_ip_address_runner_yandex_cloud" {
  value = yandex_compute_instance.runner.network_interface.0.ip_address
}
output "external_ip_address_runner_yandex_cloud" {
  value = yandex_compute_instance.runner.network_interface.0.nat_ip_address
}

# monitoring
output "internal_ip_address_monitoring_yandex_cloud" {
  value = yandex_compute_instance.monitoring.network_interface.0.ip_address
}
output "external_ip_address_monitoring_yandex_cloud" {
  value = yandex_compute_instance.monitoring.network_interface.0.nat_ip_address
}

/*
output "internal_ip_address_ _yandex_cloud" {
  value = yandex_compute_instance. .network_interface.0.ip_address
}
output "external_ip_address_ _yandex_cloud" {
  value = yandex_compute_instance. .network_interface.0.nat_ip_address
}
*/
