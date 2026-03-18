terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.88.0"  # or latest stable
    }
  }
}



provider "azurerm" {
  features {}
  subscription_id = "343c17eb-34b6-4481-92a2-a0a5a04bdd88"  # Replace with your actual subscription ID
}
# Referencing an existing resource group
data "azurerm_resource_group" "existing" {
  name = "rg-cp-shraavya-pa"  # Replace with your actual resource group name
}
# Creating an Azure OpenAI Cognitive Services Account
resource "azurerm_cognitive_account" "openai" {
  name                    = "fileon"           # Must be globally unique
  location                = data.azurerm_resource_group.existing.location
  resource_group_name     = data.azurerm_resource_group.existing.name
  kind                    = "OpenAI"
  sku_name                = "S0"
  custom_subdomain_name   = "file123"        # Must be globally unique
  # Required network_acls block
  network_acls {
    default_action = "Allow"
  }
  tags = {
    environment = "file"
  }
}


# Creating Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "fileon-law"  # Must be globally unique in your region
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "file"
  }
}

# Enable diagnostic settings for Azure OpenAI to send logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "openai_diagnostics" {
  name               = "fileon-diagnostics"
  target_resource_id = azurerm_cognitive_account.openai.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  # Enable key log categories

  enabled_log {
    category = "Audit"
}
   enabled_log {
    category = "RequestResponse"
}
   enabled_metric {
    category = "AllMetrics"
  }
}

#create an action group
resource "azurerm_monitor_action_group" "example" {
  name                = "file-action-group"
  resource_group_name = data.azurerm_resource_group.existing.name
  short_name          = "flgrp"

  email_receiver {
    name          = "shraavya"
    email_address = "shraavya.pa@kyndryl.com"
  }

  tags = {
    environment = "prod"
  }
}

resource "azurerm_monitor_metric_alert" "openai_alert" {
  name                = "fileon-openai-alert"
  resource_group_name = data.azurerm_resource_group.existing.name
  description         = "Alert when OpenAI request count exceeds threshold"
  severity            = 2
  enabled             = true
  frequency           = "PT1M" # Evaluate every 1 minute
  window_size         = "PT5M" # Check data over the last 5 minutes
  scopes              = [azurerm_cognitive_account.openai.id]

  criteria {
    metric_namespace = "Microsoft.CognitiveServices/accounts"
    metric_name      = "TotalTokens"  # Change to a metric relevant to you
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 100  # Customize this threshold as needed
  }

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }

  tags = {
    environment = "file"
  }
}





