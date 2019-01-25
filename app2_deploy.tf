#########################################################################
#
#https://www.terraform.io/docs/providers/kubernetes/r/deployment.html
#
#########################################################################


variable "app2"{
	default = 
	{
	name = "bread"
	namespace = "default"
	min_replicas = 2
	max_replicas = 10
	cpu_threshold = 80
	#image_repo = "registry-intl.ap-southeast-1.aliyuncs.com/kin-test-acr/bread"
	image_repo = "seyantszkin/bread"    	#the image is for test only, all rights reserved by Nginx
	image_ver = "v1.0"
	svc_port = 80
	container_port = 80
	svc_type = "LoadBalancer"
	}
}



resource "kubernetes_deployment" "app2" {
	
	metadata {
		name = "${var.app2["name"]}"
		labels {
			app = "${var.app2["name"]}"
		}
		namespace = "${var.app2["namespace"]}"
	}
	
	spec {
		replicas = "${var.app2["min_replicas"]}"
		
		selector {
			match_labels {
				app = "${var.app2["name"]}"
			}
		}
		
		template {
			metadata {
				labels {
					app = "${var.app2["name"]}"
				}
			}
			spec {
				container {
					image = "${var.app2["image_repo"]}:${var.app2["image_ver"]}"
					name = "${var.app2["name"]}"
					port {
						container_port = "${var.app2["container_port"]}"
						protocol = "TCP"
					}
					#resources {
					#	requests {}
					#}
				}
				#image_pull_secrets {
				#	name = "${kubernetes_secret.reg_secret.metadata.0.name}"
				#}
			
			}
		}
	
	}
	depends_on = [
	"alicloud_cs_kubernetes.k8s-cluster", 
	"alicloud_db_database.rdsdb"
	]
}


resource "kubernetes_horizontal_pod_autoscaler" "hpa2" {
  
  metadata {
    name = "${var.app2["name"]}"
  }
  spec {
    max_replicas = "${var.app2["max_replicas"]}"
    min_replicas = "${var.app2["min_replicas"]}"
	target_cpu_utilization_percentage = "${var.app2["cpu_threshold"]}"
    scale_target_ref {
      kind = "Deployment"
      name = "${var.app2["name"]}"
    }
  }
  depends_on = ["kubernetes_deployment.app2"]
}

resource "kubernetes_service" "svc2" {
	metadata {
		name = "${var.app2["name"]}-svc"
		namespace = "${var.app2["namespace"]}"
	}

	spec {
		selector {
			app = "${var.app2["name"]}"
		}
		
		port {
			port = "${var.app2["svc_port"]}"
			target_port = "${var.app2["container_port"]}"
			protocol = "TCP"
		}
		
		session_affinity = "None"
		type = "${var.app2["svc_type"]}"
		
	}
	depends_on = ["kubernetes_deployment.app2"]
}















