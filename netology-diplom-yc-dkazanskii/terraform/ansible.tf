resource "null_resource" "localsremove" {
  provisioner "local-exec" {
    command = "for okt in {1..255}; do ssh-keygen -f /home/$(whoami)/.ssh/known_hosts -R 192.168.10.$okt;  done;"
  }
}

resource "null_resource" "domainremove" {
  provisioner "local-exec" {
    command = "ssh-keygen -f /home/$(whoami)/.ssh/known_hosts -R ${var.yandex_domain}"
  }
}

resource "null_resource" "ipremove" {
  provisioner "local-exec" {
    command = "ssh-keygen -f /home/$(whoami)/.ssh/known_hosts -R ${var.yandex_external_ip}"
  }
}

resource "null_resource" "worpressdomainremove" {
  provisioner "local-exec" {
    command = "ssh-keygen -f /home/$(whoami)/.ssh/known_hosts -R app.${var.yandex_domain}"
  }
}

resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    local_file.inventory
  ]
}

# nginx
resource "null_resource" "nginx" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/nginx.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "wait2" {
  provisioner "local-exec" {
    command = "sleep 30"
  }

  depends_on = [
    null_resource.nginx
  ]
}

# mysql
resource "null_resource" "mysql" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/mysql.yml"
  }

  depends_on = [
    null_resource.wait2
  ]
}

# wordpress
resource "null_resource" "wordpress" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/wordpress.yml"
  }

  depends_on = [
    null_resource.mysql
  ]
}
/*
# gitlab
resource "null_resource" "gitlab" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -v -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/gitlab.yml"
  }

  depends_on = [
    null_resource.wordpress
  ]
}

# runner
resource "null_resource" "runner" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/runner.yml"
  }

  depends_on = [
    null_resource.gitlab
  ]
}

# monitoring
resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -vvvv -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/monitoring.yml"
  }

  depends_on = [
    null_resource.runner
  ]
}

# nodeexporter
resource "null_resource" "nodeexporter" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory/stage.yml --private-key ~/.ssh/netology.space ../ansible/nodeexporter.yml"
  }

  depends_on = [
    null_resource.monitoring
  ]
}
*/