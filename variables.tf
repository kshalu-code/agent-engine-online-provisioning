variable "tenant_project_id" {
  type        = string
  description = "The ID of the tenant project"
}

variable "tenant_project_number" {
  type        = string
  description = "The project number of the tenant project"
}

variable "location" {
  type        = string
  description = "The GCP region to deploy resources to"
}
