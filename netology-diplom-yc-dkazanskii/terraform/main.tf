terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }


  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-space-state"
    region     = "ru-central1"
    key        = "state.tfstate"
    access_key = "YCAJErEha0nSlvte-Taui3KvB"
    secret_key = "YCMs6rXINdz_t37qRluxGys7RR1KTvzh7d8vARD8"


    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  service_account_key_file = "netology-space.json"
  cloud_id                 = "${var.yandex_cloud_id}"
  folder_id                = "${var.yandex_folder_id}"
  zone      = "ru-central1-a"
}