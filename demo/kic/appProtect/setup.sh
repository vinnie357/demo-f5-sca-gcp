# ingress controller
echo -n "Enter your IC ip and press [ENTER]: "
read IC_IP
echo -n "Enter your IC port and press [ENTER]: "
read IC_HTTPS_PORT
#IC_IP=XXX.YYY.ZZZ.III
#IC_HTTPS_PORT=<port number>
# gke
echo "get GKE cluster info"
# cluster name
clusterName=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].name)

# zone
zone=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].zone)

# cluster nodes
clusterNodes=$(gcloud compute instances list --filter "name:demosca*"-clu --format json | jq -r .[].networkInterfaces[].accessConfigs[0].natIP)

# cluster creds
echo "get GKE cluster creds"
gcloud container clusters \
    get-credentials  $clusterName	 \
    --zone $zone

## deploy services
echo "deploy demo apps"
kubectl apply -f cafe-deployment.yaml
kubectl apply -f cafe-secret.yaml
kubectl apply -f dataguard-alarm.yaml
kubectl apply -f logconf.yaml

## get syslog ip
syslogIp=$(kubectl get svc syslog-svc -o json | jq -r .spec.ports[].port)
## modify ingress
cp cafe-ingress-src.yaml cafe-ingress.yaml
sed -i "s/127\.0\.0\.1/$syslogIp/g" cafe-ingress.yaml
# deploy ingress
kubectl apply -f cafe-ingress.yaml
# watch logs
echo "type yes to tail the cis logs"
read answer
if [ $answer == "yes" ]; then
    syslogPod=$(kubectl get pods -o json | jq -r ".items[].metadata | select(.name | contains (\"syslog\")).name")
    kubectl exec -it $syslogPod -- cat /var/log/messages
else
    echo "Finished"
fi
