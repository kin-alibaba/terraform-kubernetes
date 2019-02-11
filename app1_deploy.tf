#########################################################################
#
#https://www.terraform.io/docs/providers/kubernetes/r/deployment.html
#
#########################################################################

variable "app1"{
	default = 
	{
	name = "todo"
	namespace = "default"
	min_replicas = 2
	max_replicas = 10
	cpu_threshold = 80
	#image_repo = "registry-intl.ap-southeast-1.aliyuncs.com/kin-test-acr/demo"
	image_repo = "seyantszkin/demo"			#
	image_ver = "v1.0"
	svc_port = 80
	container_port = 8080
	svc_type = "LoadBalancer"
	}
}


resource "kubernetes_deployment" "app1" {
	
	metadata {
		name = "${var.app1["name"]}"
		labels {
			app = "${var.app1["name"]}"
		}
		namespace = "${var.app1["namespace"]}"
	}
	
	spec {
		replicas = "${var.app1["min_replicas"]}"
		
		selector {
			match_labels {
				app = "${var.app1["name"]}"
			}
		}
		
		template {
			metadata {
				labels {
					app = "${var.app1["name"]}"
				}
			}
			spec {
				container {
					env {
						name = "MYSQL_HOST"
						value = "${alicloud_db_instance.rdsinstance.connection_string}"
						}
					env	{
						name = "MYSQL_PORT"
						value = "3306"
						}
					env	{
						name = "DB_USERNAME"
						value = "${var.db_credential["username"]}"
						}
					env	{
						name = "DB_PASSWORD"
						value = "${var.db_credential["password"]}"
						}						
					image = "${var.app1["image_repo"]}:${var.app1["image_ver"]}"
					name = "${var.app1["name"]}"
					port {
						container_port = "${var.app1["container_port"]}"
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


resource "kubernetes_horizontal_pod_autoscaler" "hpa1" {
  
  metadata {
    name = "${var.app1["name"]}"
  }
  spec {
    max_replicas = "${var.app1["max_replicas"]}"
    min_replicas = "${var.app1["min_replicas"]}"
	target_cpu_utilization_percentage = "${var.app1["cpu_threshold"]}"
    scale_target_ref {
      kind = "Deployment"
      name = "${var.app1["name"]}"
    }
  }
  depends_on = ["kubernetes_deployment.app1"]
}

resource "kubernetes_service" "svc1" {
	metadata {
		name = "${var.app1["name"]}-svc"
		namespace = "${var.app1["namespace"]}"
	}

	spec {
		selector {
			app = "${var.app1["name"]}"
		}
		
		port {
			port = "${var.app1["svc_port"]}"
			target_port = "${var.app1["container_port"]}"
			protocol = "TCP"
		}
		
		session_affinity = "None"
		type = "${var.app1["svc_type"]}"
		
	}
	depends_on = ["kubernetes_deployment.app1"]
}















