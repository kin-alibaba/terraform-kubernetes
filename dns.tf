#########################################################################
#
#https://www.terraform.io/docs/providers/alicloud/r/dns_record.html
#https://www.terraform.io/docs/providers/alicloud/r/dns.html
#
#########################################################################

## Make sure the domain name is registered under your Alibaba Cloud account

resource "alicloud_dns_record" "svc1" {
  name = "seyantszkin.xyz"			# A domain name (e.g. alicloud.org) registered under your Alibaba Cloud account
  host_record = "${var.app1["name"]}"
  type = "A"
  value = "${kubernetes_service.svc1.load_balancer_ingress.0.ip}"
}

resource "alicloud_dns_record" "svc2" {
  name = "seyantszkin.xyz"			# A domain name registered under your Alibaba Cloud account
  host_record = "${var.app2["name"]}"
  type = "A"
  value = "${kubernetes_service.svc2.load_balancer_ingress.0.ip}"
}

resource "alicloud_dns_record" "svc3" {
  name = "seyantszkin.xyz"			# A domain name registered under your Alibaba Cloud account
  host_record = "${var.app3["name"]}"
  type = "A"
  value = "${kubernetes_service.svc3.load_balancer_ingress.0.ip}"
}
