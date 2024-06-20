output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}

output "acr_login_server" {
  value = module.container_registry.login_server
}

output "acr_admin_username" {
  value = module.container_registry.admin_username
}

output "acr_admin_password" {
  value = module.container_registry.admin_password
  sensitive = true
}