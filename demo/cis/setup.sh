#!/bin/bash
# expects sed/gcloud/jq best run in google cloud shell
# bigip
echo -n "Enter your bigip username and press [ENTER]: "
read BIGIP_ADMIN
#BIGIP_ADMIN=$( cd ../terraform/ && terraform output adminAccountName)
echo -n "Enter your bigip password and press [ENTER]: "
read -s BIGIP_PASS
#BIGIP_PASS=$( cd ../terraform/ && terraform output adminPass)
echo ""
echo "get big-ip info"
bigip1ExternalSelfIp=$(gcloud compute instances list --filter "demosca-f5vm01" --format json | jq .[0] | jq .networkInterfaces | jq -r .[0].networkIP)
bigip1ExternalNatIp=$(gcloud compute instances list --filter "demosca-f5vm01" --format json | jq .[0] | jq .networkInterfaces | jq -r .[0].accessConfigs[0].natIP)
bigip1MgmtIp=$(gcloud compute instances list --filter "demosca-f5vm01" --format json | jq .[0] | jq .networkInterfaces | jq -r .[2].networkIP)
##
# gke
echo "get GKE cluster info"
# cluster name
#gcloud container clusters list --filter "name:demosca*" --format json | jq .[].name
clusterName=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].name)

# zone
#gcloud container clusters list --filter "name:demosca*" --format json | jq .[].zone
zone=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].zone)

# cluster nodes
# gcloud compute instances list --filter "name:demosca*"-clu
# gcloud compute instances list --filter "name:demosca*"-clu --format json | jq .[].networkInterfaces[].accessConfigs[0].natIP
clusterNodes=$(gcloud compute instances list --filter "name:demosca*"-clu --format json | jq -r .[].networkInterfaces[].accessConfigs[0].natIP)

# cluster creds
echo "get GKE cluster creds"
gcloud container clusters \
    get-credentials  $clusterName	 \
    --zone $zone


## deploy services
echo "deploy demo apps"
kubectl apply -f app/juiceshop-deployment.yaml
kubectl apply -f app/juiceshop-service.yaml

## get svc port
#kubectl get svc owasp-juiceshop -o json | jq .spec.ports[].nodePort
#juiceshopServicePort=$(kubectl get svc owasp-juiceshop -o json | jq -r .spec.ports[].nodePort)
juiceshopServicePort=$(kubectl get svc owasp-juiceshop -o json | jq -r .spec.ports[].port)
# ips
# container connector
echo "set bigip-mgmtip $bigip1MgmtIp"
# f5-cluster-deployment-src.yaml > f5-cluster-deployment.yaml
cp container-controller/f5-cluster-deployment-src.yaml container-controller/f5-cluster-deployment.yaml
sed -i "s/-bigip-mgmt-address-/$bigip1MgmtIp/g" container-controller/f5-cluster-deployment.yaml
# deploy cis container
kubectl create secret generic bigip-login -n kube-system --from-literal=username="${BIGIP_ADMIN}" --from-literal=password="${BIGIP_PASS}"
kubectl create serviceaccount k8s-bigip-ctlr -n kube-system
kubectl create clusterrolebinding k8s-bigip-ctlr-clusteradmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8s-bigip-ctlr
kubectl create -f container-controller/f5-cluster-deployment.yaml
# get cis pod
#kubectl get pods --field-selector=status.phase=Running -n kube-system -o json | jq ".items[].metadata | select(.name | contains (\"k8s-bigip-ctlr\")).name"
cisPod=$(kubectl get pods --field-selector=status.phase=Running -n kube-system -o json | jq -r ".items[].metadata | select(.name | contains (\"k8s-bigip-ctlr\")).name")
# config-map nodeport
#f5-as3-configmap-juiceshop-src.yaml > f5-as3-configmap-juiceshop.yaml
cp config-maps/f5-as3-configmap-juiceshop-src.yaml config-maps/f5-as3-configmap-juiceshop.yaml
echo "set virtual address"
sed -i "s/-external-virtual-address-/$bigip1ExternalSelfIp/g" config-maps/f5-as3-configmap-juiceshop.yaml
sed -i "s/-juiceshop-service-port-/$juiceshopServicePort/g" config-maps/f5-as3-configmap-juiceshop.yaml
# apply config map
echo "apply config map"
kubectl apply -f config-maps/f5-as3-configmap-juiceshop.yaml

# finished
echo "====done===="
echo "check app at http://$bigip1ExternalNatIp"
# watch logs
sleep 30
echo "type yes to tail the cis logs"
read answer
if [ $answer == "yes" ]; then
    cisPod=$(kubectl get pods -n kube-system -o json | jq -r ".items[].metadata | select(.name | contains (\"k8s-bigip-ctlr\")).name")
    kubectl logs -f $cisPod -n kube-system | grep --color=auto -i '\[as3'
else
    echo "Finished"
fi

# 
#kubectl get nodes -o json | jq ".items[].metadata.labels | select(.node-role.kubernetes.io/master)"