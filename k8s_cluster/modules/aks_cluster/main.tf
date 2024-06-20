resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  node_resource_group = "${var.resource_group_name}-node"
  dns_prefix          = var.dns_prefix
  
  kubernetes_version = var.aks_version
  automatic_channel_upgrade = "stable"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    os_disk_size_gb = var.os_disk_size_gb
    
    zones = [ 1, 2, 3 ]
    upgrade_settings {
      drain_timeout_in_minutes = 0
      max_surge = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  # oms_agent {
  #   log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  # }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
  }


  tags = var.tags

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
      default_node_pool[0].node_count
    ]
  }
}

# resource "azurerm_log_analytics_workspace" "this" {
#   name                = "${var.resource_group_name}-log-analytics"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   sku                 = "PerGB2018"

#   retention_in_days   = 30

#   tags = var.tags
# }