# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Set the project and region for the provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Module to create GCS buckets in multiple regions within the same project
module "gcs_buckets" {
  for_each = var.bucket_regions
  source   = "git::https://github.com/terraform-google-modules/terraform-google-cloud-storage.git//modules/simple_bucket?ref=v5.0.0"

  project_id         = var.project_id
  name               = "${each.key}-${var.bucket_name_prefix}" # Bucket names are globally unique
  location           = each.value
  bucket_policy_only = true
  versioning         = var.versioning_enabled
  labels             = var.labels
  encryption         = { default_kms_key_name = var.kms_key_names[each.key] }
  lifecycle_rules = [
    {
      action    = { type = "Delete" }
      condition = { age = 2555 } # 7 years retention
    }
  ]
}

# IAM binding to disable user access in the production environment
resource "google_storage_bucket_iam_binding" "bucket_iam_prod" {
  for_each = {
    for region in keys(var.bucket_regions) :
    "${region}-${var.bucket_name_prefix}" => region
    if var.environment == "prod"
  }
  bucket = "${each.key}"
  role   = "roles/storage.objectViewer"
  members = [
    "user:dagadeepansh@google.com", # Replace with a dummy user in your organization
  ]
  depends_on = [module.gcs_buckets]
}

# Enable audit logging for the project
resource "google_project_iam_audit_config" "project_audit_config" {
  project = var.project_id
  service = "storage.googleapis.com"

  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
}

# Enable Workload Identity Federation (WIF) for the project
resource "google_iam_workload_identity_pool" "my_pool" {
  provider = google-beta
  project = var.project_id
  workload_identity_pool_id = "my-pool1"
}

resource "google_iam_workload_identity_pool_provider" "my_provider" {
  provider = google-beta
  project = var.project_id
  workload_identity_pool_id = "my-pool1"
  workload_identity_pool_provider_id = google_iam_workload_identity_pool.my_pool.workload_identity_pool_id 
  oidc { 
    issuer_uri = "https://example.com" 
  }
  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }
}

#Org policy to disable service account key creation
# resource "google_organization_policy" "disable_service_account_key_creation" {
#  org_id     = var.organization_id
#  constraint = "constraints/iam.disableServiceAccountKeyCreation"

#  boolean_policy {
#    enforced = true
#  }
# }

# #Org policy to disable automatic service account key rotation
# resource "google_organization_policy" "disable_automatic_iam_grants_for_default_service_accounts" {
#  org_id     = var.organization_id
#  constraint = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"

#  boolean_policy {
#    enforced = true
#  }
# }