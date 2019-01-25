#########################################################################
#
#https://www.terraform.io/docs/providers/alicloud/r/cs_kubernetes.html
#
#########################################################################

resource "alicloud_cs_kubernetes" "k8s-cluster" {
	name = "${var.k8clu_name}"
	vswitch_ids = [                             #Indicates Multiple Availability Zone
		"${alicloud_vswitch.vswitch1.id}",
		"${alicloud_vswitch.vswitch2.id}",
		"${alicloud_vswitch.vswitch3.id}"
	]
	master_instance_types = ["${var.master_type["zone1"]}","${var.master_type["zone1"]}","${var.master_type["zone2"]}"]
	master_disk_category = "cloud_efficiency"          #cloud_ssd or cloud_efficiency
	master_disk_size = "40"
	worker_instance_types = ["${var.worker_type["zone1"]}","${var.worker_type["zone1"]}","${var.worker_type["zone2"]}"]
	worker_disk_category = "cloud_efficiency"         #cloud_ssd or cloud_efficiency
	worker_disk_size = "40"
	worker_data_disk_category = "cloud_ssd"           #cloud_ssd or cloud_efficiency
	worker_data_disk_size = "40"
	worker_numbers = [1,1,1]
	key_name = "${alicloud_key_pair.k8s-ssh-key.key_name}"  #for ECS ssh key auth, either key_name or password 
	#password = "${var.k8ssh["password"]}"  #for ECS password auth, either key_name or password 
	new_nat_gateway = "false"
	pod_cidr = "172.20.0.0/16"
	service_cidr = "172.30.0.0/16"
	slb_internet_enabled = "true"           #for SLB of K8S API Server
	enable_ssh = "true"						#SSH login kubernetes
	install_cloud_monitor = "true"
	cluster_network_type = "terway"
	kube_config = "${var.kube_cli["cfg"]}"
	client_cert = "${var.kube_cli["client_cert"]}"
	client_key = "${var.kube_cli["client_key"]}"
	cluster_ca_cert = "${var.kube_cli["k8s_ca"]}"
	depends_on = [
	"alicloud_eip_association.eip1_asso", 
	"alicloud_snat_entry.snat1", 
	"alicloud_snat_entry.snat2", 
	"alicloud_snat_entry.snat3"
	]
	
}


