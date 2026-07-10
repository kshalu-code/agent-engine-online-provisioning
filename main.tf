# ---------------------------------------------------------------------------------
# 1. Fetch existing Cloud Run Service Agent Identity
# ---------------------------------------------------------------------------------
# We use the resource block to fetch the exact email address idempotently,
# so we can use it cleanly in the IAM binding below.
resource "google_project_service_identity" "cloudrun_sa" {
  provider = google-beta
  project  = var.tenant_project_id
  service  = "run.googleapis.com"
}

# ---------------------------------------------------------------------------------
# 2. GCS Bucket for AI Platform Staging
# ---------------------------------------------------------------------------------
resource "google_storage_bucket" "aiplatform_staging" {
  name                        = "${var.tenant_project_id}-aiplatform-staging"
  project                     = var.tenant_project_id
  location                    = var.location
  uniform_bucket_level_access = true
  force_destroy               = true
}

# ---------------------------------------------------------------------------------
# 3. IAM Delegation (Mimics VRP `GrantServiceAccountPayload`)
# Grants the Cloud Run Service Agent permission to generate tokens for the Vertex P4SA
# ---------------------------------------------------------------------------------
resource "google_service_account_iam_member" "cloudrun_p4sa_token_creator" {
  # The Resource: A generic SA in the producer project (kshalu-org-1)
  # Ensure this SA is created in the producer project before running!
  service_account_id = "projects/kshalu-org-1/serviceAccounts/generic-vertex-sa@kshalu-org-1.iam.gserviceaccount.com"
  
  role               = "roles/iam.serviceAccountTokenCreator"
  
  # The Member: The Cloud Run Service Agent for the Tenant Project
  member             = "serviceAccount:${google_project_service_identity.cloudrun_sa.email}"
}
