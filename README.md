# tf-module-azure-arm-service-app-virtual-application


Terraform module designed to add VirualApplications on an Azure PaaS Service and Function Apps.

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
  source     = "git::https://github.com/transactiveltd/tf-module-azure-arm-service-app-virtual-application.git?ref=v0.1.0"

  service_app_name    = "${data.azurerm_app_service.test.name}"
  application_names   = ["api","coolapp"]
  resource_group_name = "${data.azurerm_app_service.test.resource_group_name}"
}
```

This will run an arm template deployment on the given resource group containing the Service App and add the VirtualApplications to the specified Slot.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| service_app_name | Service App Name, e.g. `Site01` | string | - | yes |
| application_names | List of applications to create VirualApplications <br>eg: `["api","coolapps"]`| list | - | yes |
| resource_group_name | Resource Group name, e.g. `testing-service-rg` | string | - | yes |


## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | Resource Group name |
