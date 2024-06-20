locals {
  environment_vars = jsondecode(file("${path_relative_to_include()}/params.json"))
  environment      = local.environment_vars.environment
  author           = "flo@katzefudder.de"
  purpose          = "devops challenge"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

terraform {
  source = "../"
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name   = "devops-example-terraform"
    storage_account_name  = "devopstfresources"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

inputs = merge (
  local.environment_vars,
  local
)