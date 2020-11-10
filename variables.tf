variable "resource_group_name" {
  type = string
}

variable "app_service_name" {
  type = string
}

variable "application_names" {
  type = list

  description = "List of application names"
}
