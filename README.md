# terraform-azurerm-app-service-virtual-application


Terraform module designed to add VirualApplications on an Azure PaaS App Service. Modified to support terraform 0.13.5.

## Usage

### Sample
Include this repository as a module in your existing terraform code:

```hcl
# Get data from existing Service App
data "azurerm_app_service" "test" {
  name                = "testing-app-service"
  resource_group_name = "testing-service-rg"
}

# Add Virual Applications to Services App slot
module "eg_test_add_virtualApplication" {
  source     = "git::https://github.com/chamindac/terraform-azurerm-app-service-virtual-application.git?ref=0.1.5"

  app_service_name    = "${data.azurerm_app_service.test.name}"
  application_names   = ["api","coolapp"]
  resource_group_name = "${data.azurerm_app_service.test.resource_group_name}"
}
```

This will run an arm template deployment on the given resource group containing the App Service and adding the VirtualApplications.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| app_service_name | Service App Name, e.g. `Site01` | string | - | yes |
| application_names | List of applications to create VirualApplications <br>eg: `["api","coolapps"]`| list | - | yes |
| resource_group_name | Resource Group name, e.g. `testing-service-rg` | string | - | yes |
