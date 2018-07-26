variable "resource_group_name" {
  type = "string"
}

variable "service_app_name" {
  type = "string"
}

variable "application_names" {
  type = "list"

  description = "List of application names"
}
