# GCS PCI Compliant Module

This Terraform module creates Google Cloud Storage buckets adhering to PCI compliance standards, utilizing the `terraform-google-modules/cloud-storage/google` module.

## Features

-   Creates GCS buckets in specified regions.
-   Enforces uniform bucket-level access using `bucket_policy_only`.
-   Enables versioning (optional).
-   Applies CMEK encryption.
-   Sets a 7-year data retention policy.
-   Disables user access in production environments.
-   Enables audit logging.
-   Applies organization policies to:
    -   Disable service account key creation.
    -   Disable automatic service account key rotation.

## Usage

```terraform
module "pci_compliant_storage" {
  source = "./gcs-pci-module"

  project_ids = {
    "Toronto"   = "your-project-id-tor"
    "Montreal"  = "your-project-id-mon"
    "Virginia"  = "your-project-id-vir"
    "mexico"    = "your-project-id-mex"
    "LATAM"    = "your-project-id-latam"
  }
  bucket_name_prefix = "scotiabank-pci-data"
  environment        = "prod"
  organization_id   = "your-org-id"
  project_id         = "your-default-project-id"
  region             = "your-default-region" # Optional: Set a default region
  kms_key_names = {
    "Toronto"   = "projects/your-project-id-tor/locations/northamerica-northeast1/keyRings/your-keyring-tor/cryptoKeys/your-key-tor"
    "Montreal"  = "projects/your-project-id-mon/locations/northamerica-northeast2/keyRings/your-keyring-mon/cryptoKeys/your-key-mon"
    "Virginia"  = "projects/your-project-id-vir/locations/us-east4/keyRings/your-keyring-vir/cryptoKeys/your-key-vir"
    "mexico"    = "projects/your-project-id-mex/locations/us-central1/keyRings/your-keyring-mex/cryptoKeys/your-key-mex"
    "LATAM"    = "projects/your-project-id-latam/locations/southamerica-east1/keyRings/your-keyring-latam/cryptoKeys/your-key-latam"
  }
}
```

projects/bootstrap-prjct/locations/ca/keyRings/pci-keyring/cryptoKeys/pci-key-tor/cryptoKeyVersions/1


# Org policy to disable service account key creation
#resource "google_organization_policy" "disable_service_account_key_creation" {
#  org_id     = var.organization_id
#  constraint = "constraints/iam.disableServiceAccountKeyCreation"
#
#  boolean_policy {
#    enforced = true
#  }
#}

# Org policy to disable automatic service account key rotation
#resource "google_organization_policy" "disable_automatic_iam_grants_for_default_service_accounts" {
#  org_id     = var.organization_id
#  constraint = "constraints/iam.automaticIamGrantsForDefaultServiceAccounts"
#
#  boolean_policy {
#    enforced = true
#  }
#}