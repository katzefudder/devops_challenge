# CGI DevOps Challenge

## Get access to AKS
`az aks install-cli`
`cd _live && terragrunt apply -auto-apply`

## Set kube config via az
`az aks get-credentials --resource-group DevOpsChallenge --name DevOpsChallenge-live`

## Upload built container image to ECR using Terraform
```
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
ACR_USERNAME=$(terraform output -raw acr_admin_username)
ACR_PASSWORD=$(terraform output -raw acr_admin_password)
docker login $ACR_LOGIN_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD
```

```
docker build -t mynginx --platform linux/amd64 .
docker tag mynginx $ACR_LOGIN_SERVER/mynginx:latest
docker push $ACR_LOGIN_SERVER/mynginx:latest
```

# Monitoring
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install -n monitoring prometheus-operator prometheus-community/kube-prometheus-stack
```

# Force Reconciliation
`kubectl annotate certificate katzefudder-tls -n nginx "kubectl.kubernetes.io/reconcile=true"`

# Test Host Header
`curl --resolve "devops.katzefudder.dev:443:4.182.186.225" https://devops.katzefudder.dev`