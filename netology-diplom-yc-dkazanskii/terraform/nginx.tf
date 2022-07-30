resource "yandex_compute_instance" "nginx" {
  name     = "nginx"
  hostname = "${var.yandex_domain}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 6
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet-1.id
    nat            = true
    nat_ip_address = var.yandex_external_ip
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}