resource "kubernetes_secret" "reg_secret" {			#private Docker registry credential
	metadata {
		name = "tf-reg-secret"
		namespace = "default"
		
	}
	data {
		".dockerconfigjson" = "${file("./config.json")}"		#path of Docker config file which contains registry credential and in json format
	}
	type = "kubernetes.io/dockerconfigjson"
	depends_on = [
	"alicloud_cs_kubernetes.k8s-cluster",
	]
}
