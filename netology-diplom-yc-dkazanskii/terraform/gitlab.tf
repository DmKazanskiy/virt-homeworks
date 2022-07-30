resource "yandex_compute_instance" "gitlab" {
  name     = "gitlab"
  hostname = "gitlab.${var.yandex_domain}"
  allow_stopping_for_update = true

  resources {
    cores  = 6 
    memory = 12 
  }

  boot_disk {
    initialize_params {
      image_id = "fd8fte6bebi857ortlja"
      size     = 50
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = false    
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}