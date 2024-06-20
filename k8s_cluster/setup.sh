#!/bin/bash
set -euo pipefail

ENVIRONMENT=$1
CURR_PATH=$(pwd)
ENVIRONMENT=$CURR_PATH/_$ENVIRONMENT
DOCKER_PATH=$CURR_PATH/assets/docker
K8S_PATH=$CURR_PATH/assets/kubernetes

cd $ENVIRONMENT && terragrunt init && terragrunt apply -auto-approve
az aks get-credentials --resource-group DevOpsChallenge --name DevOpsChallenge-live

ACR_LOGIN_SERVER=$(terragrunt output -raw acr_login_server)
ACR_USERNAME=$(terragrunt output -raw acr_admin_username)
ACR_PASSWORD=$(terragrunt output -raw acr_admin_password)
docker login $ACR_LOGIN_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD

cd $DOCKER_PATH
docker build -t mynginx --platform linux/amd64 .
docker tag mynginx $ACR_LOGIN_SERVER/mynginx:latest
docker push $ACR_LOGIN_SERVER/mynginx:latest

# make sure the file cloudflare_token exists, injecting it into manifest
export CLOUDFLARE_TOKEN=$(cat $K8S_PATH/cloudflare_token)
cd $K8S_PATH && echo $CLOUDFLARE_TOKEN | envsubst < app.yaml | kubectl apply -f -

cd $ENVIRONMENT
ACR_LOGIN_SERVER=$(terragrunt output -raw acr_login_server)
ACR_USERNAME=$(terragrunt output -raw acr_admin_username)
ACR_PASSWORD=$(terragrunt output -raw acr_admin_password)
docker login $ACR_LOGIN_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD

# create dockerconfig secret
kubectl create secret docker-registry dockerconfig \
--docker-server=$ACR_LOGIN_SERVER \
--docker-username=$ACR_USERNAME \
--docker-password=$ACR_PASSWORD \
--docker-email=yourmail@yourdomain.com \
--namespace=nginx || true # don't fail 

