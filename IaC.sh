#!/bin/bash

terraform init 

###It is critical to clear the .kube directory and create empty files for Terraform to proceed

rm -rf ~/.kube.old/*
mv ~/.kube ~/.kube.old.`date +%s`
mv ./k8s-ssh-key.pem ./k8s-ssh-key.pem.`date +%s`
mkdir ~/.kube
touch ~/.kube/cluster-ca-cert.pem
touch ~/.kube/client-key.pem
touch ~/.kube/client-cert.pem

if [ ! `terraform state list` ]; then
	terraform apply -auto-approve
else
	terraform apply
fi

#for resource in `terraform state list`
#do
#	terraform state rm ${reosurce}
#done
