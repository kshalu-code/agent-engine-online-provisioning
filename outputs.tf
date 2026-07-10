output "tenant_project_id" {
  description = "The ID of the tenant project"
  value       = var.tenant_project_id
}

output "aiplatform_staging_bucket" {
  description = "The name of the GCS bucket created for AI Platform staging"
  value       = google_storage_bucket.aiplatform_staging.name
}

