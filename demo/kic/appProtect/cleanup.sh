#!/bin/bash
# expects sed/gcloud/jq best run in google cloud shell
# assumes setup has been run
# cluster name
clusterName=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].name)
# zone
zone=$(gcloud container clusters list --filter "name:demosca*" --format json | jq -r .[].zone)
# project
project=$(gcloud info --format json | jq -r .config.project)
# cluster creds
gcloud container clusters \
    get-credentials  $clusterName	 \
    --zone $zone
# delete kic
kubectl delete
# delete app deployments
kubectl delete svc

echo "====Done===="