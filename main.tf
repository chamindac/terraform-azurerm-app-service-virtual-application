resource "azurerm_template_deployment" "service_app_virtual_application" {
  name                = "${format("%s-arm-virtual-directories", var.webapp_name)}"
  resource_group_name = "${var.resource_group_name}"
  deployment_mode     = "Incremental"

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "serviceAppName": {
      "type": "string"
    }
    "applicationNames":{
      "type": "string"
    }
  },
  "variables": {
      "directoryNames" :"[split(parameters('applicationNames'),',')]",
       "child": {
            "copy": [
                {
                    "name": "dir",
                    "count": "[length(variables('directoryNames'))]",
                    "input": {
                        "virtualPath": "[concat('/', variables('directoryNames')[copyIndex('dir')]) ]",
                        "physicalPath": "[concat('site\\wwwroot\\', variables('directoryNames')[copyIndex('dir')]) ]",
                        "preloadEnabled": false,
                        "virtualDirectories": null
                    }

                }
            ]
        },
        "root":[
            {
                "virtualPath": "/",
                "physicalPath": "site\\wwwroot",
                "preloadEnabled": false,
                "virtualDirectories": null
            }
        ],
        "virtualDirectories":"[union(variables('child').dir, variables('root'))]"
  },
  "resources": [
    {
      "comments": "WebApp VirtualDirectories",
      "type": "Microsoft.Web/sites/config",
      "name": "[concat(parameters('serviceAppName'), '/web')]",
      "apiVersion": "2016-08-01",
      "properties": {
        "virtualApplications": "[variables('virtualDirectories')]"
        },
      "dependsOn": []
    }
  ]
}
DEPLOY

  parameters {
    "serviceAppName"   = "${var.service_app_name}"
    "applicationNames" = "${join(",",var.application_names)}"
  }

  depends_on = []
}
