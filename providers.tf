#########################################################################
#Download Terraform at 
#https://releases.hashicorp.com/terraform/0.11.11/
#
#Download Terraform provider at 
#https://releases.hashicorp.com/terraform-provider-kubernetes/1.5.0/
#https://releases.hashicorp.com/terraform-provider-alicloud/1.29.0/
#
#########################################################################

provider "alicloud" {
access_key = "${var.access_key}"
secret_key = "${var.secret_key}"
region = "${var.region}"
}

provider "kubernetes" {			#Make it depends on a another resources
	host = "https://${alicloud_cs_kubernetes.k8s-cluster.connections["master_public_ip"]}:6443"
	client_certificate     = "${file("${var.kube_cli["client_cert"]}")}"
	client_key             = "${file("${var.kube_cli["client_key"]}")}"
	cluster_ca_certificate = "${file("${var.kube_cli["k8s_ca"]}")}"
}

