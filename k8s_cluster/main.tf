terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "devops_challenge" {
  name     = "${var.resource_group_name}"
  location = var.location
  tags = {
    author = var.author
    purpose = var.purpose
  }
}

module "container_registry" {
  source = "./modules/container_registry"
  environment = var.environment
  container_registry_name = "${var.container_registry_name}"
  resource_group_name = azurerm_resource_group.devops_challenge.name
  location = azurerm_resource_group.devops_challenge.location
  tags = {
    Environment = var.environment
    author = var.author
    purpose = var.purpose
  }
}

module "aks" {
  source = "./modules/aks_cluster"
  environment = var.environment
  aks_version = var.aks_version
  cluster_name = "${var.project}-${var.environment}"
  location = azurerm_resource_group.devops_challenge.location
  resource_group_name = azurerm_resource_group.devops_challenge.name
  dns_prefix = var.dns_prefix
  domain_name_label = var.domain_name_label
  node_count = var.node_count
  os_disk_size_gb = var.os_disk_size_gb
  vm_size = var.vm_size

  tags = {
    Environment = var.environment
    author = var.author
    purpose = var.purpose
  }
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "kube-system"
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
  
  values = [
    file("${path.module}/templates/ingress-nginx-values.yaml")
  ]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.7.1"

  namespace        = "cert-manager"
  create_namespace = true

  #values = [file("cert-manager-values.yaml")]

  set {
    name  = "installCRDs"
    value = "true"
  }
}
