#########################################################################
#
#https://www.terraform.io/docs/providers/alicloud/r/db_instance.html
#https://www.terraform.io/docs/providers/alicloud/r/db_database.html
#https://www.terraform.io/docs/providers/alicloud/r/db_account.html
#https://www.terraform.io/docs/providers/alicloud/r/db_account_privilege.html
#
#########################################################################

##Provision a Alibaba Cloud ApsaraRDS for MySQL instance with a DB for an app running on K8S to use

resource "alicloud_db_instance" "rdsinstance" {
	engine = "MySQL"
	engine_version = "5.6"
	instance_type = "rds.mysql.t1.small"
	instance_storage = "5"
	vswitch_id = "${alicloud_vswitch.vswitch1.id}"
	security_ips = ["${var.vswitch_cidr1}", "${var.vswitch_cidr2}", "${var.vswitch_cidr3}", "${alicloud_eip.eip1.ip_address}"]
	#depends_on = ["alicloud_cs_kubernetes.k8s-cluster"]
}

resource "alicloud_db_database" "rdsdb" {
	instance_id = "${alicloud_db_instance.rdsinstance.id}"
	name = "demodb"
	character_set = "utf8"
}

resource "alicloud_db_account" "mysqlroot" {
	instance_id = "${alicloud_db_instance.rdsinstance.id}"
	name = "${var.db_credential["username"]}"
	password = "${var.db_credential["password"]}"
}

resource "alicloud_db_account_privilege" "default" {
	instance_id = "${alicloud_db_instance.rdsinstance.id}"
	account_name = "${alicloud_db_account.mysqlroot.name}"
	privilege = "ReadWrite"
	db_names = ["${alicloud_db_database.rdsdb.name}"]
}

#resource "alicloud_db_connection" "default" { 				#Internet connection prefix
#    instance_id = "${alicloud_db_instance.rdsinstance.id}"
#    connection_prefix = "kin-k8s-test"
#    port = "3306"
#	depends_on = ["alicloud_db_account_privilege.default", "alicloud_cs_kubernetes.k8s-cluster"]
#}
