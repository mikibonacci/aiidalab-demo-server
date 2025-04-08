#!/bin/bash

source ../secrets_psischool.txt

echo ${K8S_NAMESPACE}

helm dependency build basehub 2> /dev/null || echo "No dependencies to update or install"

jinja2 --format=env jinja_templates/storageclass.yaml.j2 > basehub/templates/storageclass.yaml
jinja2 --format=env jinja_templates/values.yaml.j2 > basehub/values.yaml

cp ../allowed_users_lists/${K8S_NAMESPACE}.yaml basehub/files/allowed_users_list.yaml

# JupyterHub
helm upgrade \
	--install \
	--cleanup-on-fail \
	--create-namespace --namespace=${K8S_NAMESPACE} \
	${K8S_NAMESPACE} basehub
