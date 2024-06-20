output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "resource_group_name" {
  value = azurerm_kubernetes_cluster.this.resource_group_name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].host
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].client_key
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
}

# output "public_ipaddress" {
#   value = azurerm_public_ip.this.ip_address
# }

# output "public_ip_name" {
#   value = azurerm_public_ip.this.name
# }
# output "fqdn" {
#   value = azurerm_public_ip.this.fqdn
# }