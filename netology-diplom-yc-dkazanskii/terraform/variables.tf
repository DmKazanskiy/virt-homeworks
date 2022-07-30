variable "yandex_external_ip" { 
  default = "51.250.88.169" 
}

# yc resource-manager cloud list --format yaml
variable "yandex_cloud_id" {
  default = "b1g33tisd4sbvsb0acjg"
}

# yc resource-manager folder list --format yaml
variable "yandex_folder_id" {
  default = "b1gslqvhkabm1n1mbf3j"
}

#static access key id
variable "yandex_sa_id" {
  default = "aje6vhumrh8p6r1904ie"
}

variable "yandex_domain" {
  default = "netology.space"
}


# yc compute image list --folder-id standard-images | grep -E "ubuntu-20-04-lts.*v202207"

variable "yandex_cloud_image_id" {
  #default = "fd826dalmbcl81eo5nig"
  default = "fd8fte6bebi857ortlja"
  #default  = "fd84mnpg35f7s7b0f5lg"
}

variable "yandex_ubuntu_user" {
  default = "ubuntu"
}

# Производительность CPU
variable "yandex_cloud_core_fraction" {
  type    = number
  default = 100
}

# Прерываемая ВМ
variable "yandex_cloud_preemptible" {
  type    = bool
  default = true
}
# Использовать тестовые сертификаты
variable "test_cert" {
  default = "--test-cert"
}
variable "database_name" {
  default = "wordpress"
}

variable "database_user" {
  default = "wordpress"
}

variable "database_password" {
  default = "wordpress"
}

variable "database_replication_masternode" {
  default = "db01"
}

variable "database_replication_user" {
  default = "replicausr"
}

variable "database_replication_user_password" {
  default = "REplicauserpass123"
}

