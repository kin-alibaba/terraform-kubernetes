#########################################################################
#
#https://www.terraform.io/docs/providers/alicloud/r/vpc.html
#
#########################################################################

##Setting up K8S network prerequisites, VPC, 3 vswitches in 3 AZ, security group & rule and NAT gateway with an EIP & SNAT rules

resource "alicloud_vpc" "vpc" {
name = "${var.vpc_name}"
cidr_block = "${var.vpc_cidr}"
}

resource "alicloud_vswitch" "vswitch1" {
availability_zone = "${var.azone1}"
name = "${var.vswitch_name1}"
cidr_block = "${var.vswitch_cidr1}"
vpc_id = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_vswitch" "vswitch2" {
availability_zone = "${var.azone1}"
name = "${var.vswitch_name2}"
cidr_block = "${var.vswitch_cidr2}"
vpc_id = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_vswitch" "vswitch3" {
availability_zone = "${var.azone3}"
name = "${var.vswitch_name3}"
cidr_block = "${var.vswitch_cidr3}"
vpc_id = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_security_group" "sg" {
name = "${var.sg_name}"
vpc_id = "${alicloud_vpc.vpc.id}"
}

resource "alicloud_security_group_rule" "22_rule" {
security_group_id = "${alicloud_security_group.sg.id}"
type = "ingress"
policy = "accept"
port_range = "22/22"
ip_protocol = "tcp"
nic_type = "intranet"
priority = 1
cidr_ip = "0.0.0.0/0"
}


resource "alicloud_nat_gateway" "nat_gateway" {
  vpc_id = "${alicloud_vpc.vpc.id}"
  specification   = "Small"
  name   = "kin-k8s-tf-nat-gw"
  depends_on = [
     "alicloud_vswitch.vswitch1",
     "alicloud_vswitch.vswitch2",
     "alicloud_vswitch.vswitch3"
  ]
}


resource "alicloud_eip" "eip1" {
  bandwidth            = "20"
}

resource "alicloud_eip_association" "eip1_asso" {
  allocation_id = "${alicloud_eip.eip1.id}"
  instance_id   = "${alicloud_nat_gateway.nat_gateway.id}"
}

resource "alicloud_snat_entry" "snat1" {
  snat_table_id     = "${alicloud_nat_gateway.nat_gateway.snat_table_ids}"
  source_vswitch_id = "${alicloud_vswitch.vswitch1.id}"
  snat_ip           = "${alicloud_eip.eip1.ip_address}"
}

resource "alicloud_snat_entry" "snat2" {
  snat_table_id     = "${alicloud_nat_gateway.nat_gateway.snat_table_ids}"
  source_vswitch_id = "${alicloud_vswitch.vswitch2.id}"
  snat_ip           = "${alicloud_eip.eip1.ip_address}"
}

resource "alicloud_snat_entry" "snat3" {
  snat_table_id     = "${alicloud_nat_gateway.nat_gateway.snat_table_ids}"
  source_vswitch_id = "${alicloud_vswitch.vswitch3.id}"
  snat_ip           = "${alicloud_eip.eip1.ip_address}"
}


