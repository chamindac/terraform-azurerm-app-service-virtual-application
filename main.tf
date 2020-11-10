resource "azurerm_template_deployment" "service_app_virtual_application" {
  name                = "${format("%s-arm-virtual-directories", var.app_service_name)}"
  resource_group_name = "${var.resource_group_name}"
  deployment_mode     = "Incremental"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appServiceName": {
            "type": "String"
        },
        "applicationNames": {
            "type": "String"
        }
    },
    "variables": {
        "appNames": "[union(variables('wwwroot'),split(parameters('applicationNames'),','))]",
        "virtual": {
            "copy": [
                {
                    "count": "[length(variables('appNames'))]",
                    "input": {
                        "physicalPath": "[concat('site\\wwwroot\\', variables('appNames')[copyIndex('apps')]) ]",
                        "preloadEnabled": false,
                        "virtualDirectories": null,
                        "virtualPath": "[concat('/', variables('appNames')[copyIndex('apps')]) ]"
                    },
                    "name": "apps"
                }
            ]
        },
        "wwwroot": "[split('',',')]"
    },
    "resources": [
        {
            "type": "Microsoft.Web/sites/config",
            "name": "[concat(parameters('appServiceName'), '/web')]",
            "apiVersion": "2016-08-01",
            "properties": {
                "virtualApplications": "[variables('virtual').apps]"
            },
            "dependsOn": []
        }
    ],
    "outputs": {
        "virtualApplications": {
            "type": "Array",
            "value": "[variables('virtual').apps]"
        }
    }
}
DEPLOY

  parameters {
    appServiceName   = var.app_service_name
    applicationNames = "${join(",",var.application_names)}"
  }

  depends_on = []
}
