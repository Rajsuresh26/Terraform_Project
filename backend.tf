terraform {
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
    key                  = "prod.terraform.tfstate"
    #use_msi              = true
    #subscription_id      = "9f8ba3e4-1c54-4f3d-8280-6c1e098df386"
    #tenant_id            = "71270b92-59dd-4f9a-b6cc-9b5639e6cdf0"
  }
}
