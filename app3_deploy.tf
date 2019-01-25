#########################################################################
#
#https://www.terraform.io/docs/providers/kubernetes/r/deployment.html
#
#########################################################################


variable "app3"{
	default = 
	{
	name = "butter"
	namespace = "default"
	min_replicas = 2
	max_replicas = 10
	cpu_threshold = 80
	#image_repo = "registry-intl.ap-southeast-1.aliyuncs.com/XXXXXX/butter"
	image_repo = "seyantszkin/butter"   #the image is for test only, all rights reserved by Nginx
	image_ver = "v1.0"
	svc_port = 80
	container_port = 80
	svc_type = "LoadBalancer"
	}
}



resource "kubernetes_deployment" "app3" {
	
	metadata {
		name = "${var.app3["name"]}"
		labels {
			app = "${var.app3["name"]}"
		}
		namespace = "${var.app3["namespace"]}"
	}
	
	spec {
		replicas = "${var.app3["min_replicas"]}"
		
		selector {
			match_labels {
				app = "${var.app3["name"]}"
			}
		}
		
		template {
			metadata {
				labels {
					app = "${var.app3["name"]}"
				}
			}
			spec {
				container {
					image = "${var.app3["image_repo"]}:${var.app3["image_ver"]}"
					name = "${var.app3["name"]}"
					port {
						container_port = "${var.app3["container_port"]}"
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


resource "kubernetes_horizontal_pod_autoscaler" "hpa3" {
  
  metadata {
    name = "${var.app3["name"]}"
  }
  spec {
    max_replicas = "${var.app3["max_replicas"]}"
    min_replicas = "${var.app3["min_replicas"]}"
	target_cpu_utilization_percentage = "${var.app3["cpu_threshold"]}"
    scale_target_ref {
      kind = "Deployment"
      name = "${var.app3["name"]}"
    }
  }
  depends_on = ["kubernetes_deployment.app3"]
}

resource "kubernetes_service" "svc3" {
	metadata {
		name = "${var.app3["name"]}-svc"
		namespace = "${var.app3["namespace"]}"
	}

	spec {
		selector {
			app = "${var.app3["name"]}"
		}
		
		port {
			port = "${var.app3["svc_port"]}"
			target_port = "${var.app3["container_port"]}"
			protocol = "TCP"
		}
		
		session_affinity = "None"
		type = "${var.app3["svc_type"]}"
		
	}
	depends_on = ["kubernetes_deployment.app3"]
}















