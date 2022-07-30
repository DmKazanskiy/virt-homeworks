#inventory.tf
resource "local_file" "inventory" {
  content = <<-DOC
    ---
    nginx_install:
      hosts:
        nginx:
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}
          letsencrypt_email: "dmkazanskii@yandex.ru"
          domain_name: "${var.yandex_domain}"

    mysql:
      hosts:
        db01:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.db01.network_interface.0.ip_address}
          mysql_server_id: 1
          mysql_replication_role: master
        db02:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.db02.network_interface.0.ip_address}
          mysql_server_id: 2 
          mysql_replication_role: slave
    wordpress_install:
      hosts:
        app:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.app.network_interface.0.ip_address}
    gitlab_install:
      hosts:
        gitlab:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
    runner_install:
      hosts:
        runner:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.runner.network_interface.0.ip_address}
    monitoring_install:
      hosts:
        monitoring:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
        nodeexporter:
          ansible_ssh_common_args: '-o ProxyCommand="ssh -i ~/.ssh/netology.space -o StrictHostKeyChecking=no -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}"'
          ansible_user: "${var.yandex_ubuntu_user}"
          ansible_host: ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
    DOC
  filename = "../ansible/inventory/stage.yml"

  depends_on = [
    yandex_compute_instance.nginx,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.runner,
    yandex_compute_instance.monitoring
  ]
}
#inventory.tf
resource "local_file" "res" {
  content = <<-DOC
    ---
    #nginx
    ssh -i ~/.ssh/netology.space ubuntu@${yandex_compute_instance.nginx.network_interface.0.nat_ip_address}
    
    #db01
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.db01.network_interface.0.ip_address}
    
    #db02:
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.db02.network_interface.0.ip_address}
    
    #wordpress-install:
    #app:
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.app.network_interface.0.ip_address}

    #gitlab:
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.gitlab.network_interface.0.ip_address}

    #runner:
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.runner.network_interface.0.ip_address}

    #monitoring:
    ssh -i ~/.ssh/netology.space -o "ProxyCommand ssh -i ~/.ssh/netology.space -W %h:%p ${var.yandex_ubuntu_user}@${var.yandex_external_ip}" ${var.yandex_ubuntu_user}@${yandex_compute_instance.monitoring.network_interface.0.ip_address}
    DOC
  filename = "../stage_ssh.txt"

  depends_on = [
    yandex_compute_instance.nginx,
    yandex_compute_instance.db01,
    yandex_compute_instance.db02,
    yandex_compute_instance.app,
    yandex_compute_instance.gitlab,
    yandex_compute_instance.runner,
    yandex_compute_instance.monitoring
  ]
}
