terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  subscription_id = "ed303178-6b93-47ba-a666-b5ff8724fba0"
}

variable "resource_group_name" {
  default = "margies-search-rg"
}

variable "location" {
  default = "eastus" # must match between Azure AI Search and Azure AI Services
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_cognitive_account" "ai_services" {
  name                          = "margiesmultiaiacct"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  kind                          = "CognitiveServices"
  sku_name                      = "S0"
  custom_subdomain_name         = "margiesmulti"
  public_network_access_enabled = true
  restore                       = true 

  tags = {
    environment = "demo"
  }
}

resource "azurerm_search_service" "ai_search" {
  name                = "margiessearchsvc"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "basic"
  replica_count   = 1
  partition_count = 1
}

resource "azurerm_storage_account" "storage" {
  name                     = "margiesstorageacct" # must be globally unique
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  allow_nested_items_to_be_public = true

  tags = {
    environment = "demo"
  }
}

resource "azurerm_storage_container" "documents" {
  name                  = "margies"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_primary_key" {
  value     = azurerm_storage_account.storage.primary_access_key
  sensitive = true
}

output "ai_services_key" {
  value     = azurerm_cognitive_account.ai_services.primary_access_key
  sensitive = true
}

output "ai_services_endpoint" {
  value = azurerm_cognitive_account.ai_services.endpoint
}

output "search_service_endpoint" {
  value = azurerm_search_service.ai_search.query_keys[0]
}

output "search_admin_key" {
  value     = azurerm_search_service.ai_search.primary_key
  sensitive = true
}

output "storage_container_name" {
  value = azurerm_storage_container.documents.name
}

