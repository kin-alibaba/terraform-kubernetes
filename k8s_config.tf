variable "k8clu_name" {
default = "kin-k8s-tf-maz"			#K8S cluster name
}

variable "master_type" {
	default = {
	zone1 = "ecs.sn2ne.large"		#Please make sure the ECS type is available in the specified Availability Zone 
	zone2 = "ecs.sn2ne.large"		#Please make sure the ECS type is available in the specified Availability Zone 
	}
}

variable "worker_type" {
	default = {
	zone1 = "ecs.sn2ne.large"		#Please make sure the ECS type is available in the specified Availability Zone 
	zone2 = "ecs.sn2ne.large"		#Please make sure the ECS type is available in the specified Availability Zone 
	}
}

variable "k8ssh" {
	default = {
	keypair = "k8s-ssh-key" #key pair in KMS	
	password = "Password#3"	#SSH password if not using SSH Key
	}
}

resource "alicloud_key_pair" "k8s-ssh-key" {
	key_name = "${var.k8ssh["keypair"]}"
	key_file = "./k8s-ssh-key.pem"		#key file output path in your local machine
}

variable "kube_cli" {			#K8S config & key files output path in your local machine
	default = {
	cfg = "~/.kube/config"
	client_cert = "~/.kube/client-cert.pem"
	client_key = "~/.kube/client-key.pem"
	k8s_ca = "~/.kube/cluster-ca-cert.pem"
	}
}