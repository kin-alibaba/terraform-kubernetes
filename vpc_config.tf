variable "region" {
default = "cn-hongkong"
}

variable "azone1" {
default = "cn-hongkong-b"
}

variable "azone2" {
default = "cn-hongkong-c"
}

variable "azone3" {
default = "cn-hongkong-c"
}

variable "vpc_name" {
default = "kin-tf-k8s-vpc-hk"
}

variable "vpc_cidr" {
default = "10.0.0.0/8"
}

variable "vswitch_name1" {
default = "kin-tf-k8s-vsw1"
}

variable "vswitch_cidr1" {
default = "10.0.1.0/24"
}

variable "vswitch_name2" {
default = "kin-tf-k8s-vsw2"
}

variable "vswitch_cidr2" {
default = "10.0.2.0/24"
}

variable "vswitch_name3" {
default = "kin-tf-k8s-vsw3"
}

variable "vswitch_cidr3" {
default = "10.0.3.0/24"
}

variable "sg_name" {
default = "kin-tf-k8s-sg"
}


