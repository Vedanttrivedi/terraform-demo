#Resource group
data "azurerm_resource_group" "example" {
  name     = "sa1_test_eic_VedantTrivedi"
}
#create app service plan
resource "azurerm_app_service_plan" "example" {
  name                = "my-appService-plan"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = {
    environment="Test"
    Owner="Shiv Modi"
    BusinessOwner="Sachin Koshti"
    BusinessUnit="EInfochips"
    SubBusinessUnit="PES-Intelligent Automation"
  }
}

resource "azurerm_application_insights" "application-insights" {
  name                = "tf-test-appinsights"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_app_service" "app_service" {
  name                = "myFirst-web-app"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    linux_fx_version = "Dotnet|8"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
    "APPINSIGHTS_INSTRUMENTATIONKEY" =  azurerm_application_insights.application-insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" =  azurerm_application_insights.application-insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION"="~2"
  }
  tags = {
    environment="Test"
    Owner="Shiv Modi"
    BusinessOwner="Sachin Koshti"
    BusinessUnit="EInfochips"
    SubBusinessUnit="PES-Intelligent Automation"
  }


  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}


resource "azurerm_monitor_autoscale_setting" "example" {
  name = "memoryAutoScale-new"
  resource_group_name = data.azurerm_resource_group.example.name
  location = data.azurerm_resource_group.example.location
  target_resource_id = azurerm_app_service_plan.example.id

  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name = "MemoryPercentage"
        metric_resource_id = azurerm_app_service_plan.example.id
        metric_namespace   = "Microsoft.Web/serverfarms"
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT1M"
        time_aggregation   = "Average"
        operator = "GreaterThanOrEqual"
        threshold = 90
      }

      scale_action {
        direction = "Increase"
        type = "ChangeCount"
        value = 1
        cooldown = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name = "MemoryPercentage"
        metric_resource_id = azurerm_app_service_plan.example.id
        metric_namespace   = "Microsoft.Web/serverfarms"
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT1M"
        time_aggregation   = "Average"
        operator = "LessThanOrEqual"
        threshold = 80
      }

      scale_action {
        direction = "Decrease"
        type = "ChangeCount"
        value = 1
        cooldown = "PT1M"
      }
    }
  }
}



output "instrumentation_key" {
  value = azurerm_application_insights.application-insights.instrumentation_key
  sensitive = true
}

output "app_id" {
  value = azurerm_application_insights.application-insights.app_id
  sensitive = true
}
