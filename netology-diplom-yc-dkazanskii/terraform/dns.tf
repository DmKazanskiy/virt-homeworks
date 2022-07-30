resource "yandex_dns_zone" "zonepub" {
  name        = "pub-netology-diplom-zone"
  description = "public zone"
  labels = {
    label1 = "netology-public"
  }  
  public = true
  zone   = "netology.space."

}
resource "yandex_dns_recordset" "rec0" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}

resource "yandex_dns_recordset" "rec2" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "www.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}
resource "yandex_dns_recordset" "rec3" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "gitlab.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}

resource "yandex_dns_recordset" "rec4" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "grafana.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}

resource "yandex_dns_recordset" "rec5" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "prometheus.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}
resource "yandex_dns_recordset" "rec6" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "alertmanager.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}
resource "yandex_dns_recordset" "rec7" {
  zone_id = yandex_dns_zone.zonepub.id
  name    = "app.netology.space."
  type    = "A"
  ttl     = 600
  data    = ["${var.yandex_external_ip}"]
}
