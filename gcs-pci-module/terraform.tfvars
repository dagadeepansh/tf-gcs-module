project_id           = "bootstrap-prjct"
region               = "us-central1"
environment          = "prod"
organization_id      = "514831531729"  # Replace with your organization ID
#non_prod_bucket_names = ["test-bucket1", "test-bucket2"]
#bucket_name_prefix      = "pci-data"
#bucket_location_mexico  = "northamerica-northeast1"
#bucket_location_latam   = "southamerica-east1"
#storage_class           = "STANDARD"
#kms_key_name            = "projects/your-project-id/locations/global/keyRings/my-keyring/cryptoKeys/my-key"
#log_bucket_name         = "pci-data-logs"
#retention_policy_days   = 2555
kms_key_names = {
  "northamerica-northeast1"   = "projects/bootstrap-prjct/locations/northamerica-northeast1/keyRings/pci-ring/cryptoKeys/pci-key-mon"
  "northamerica-northeast2"   = "projects/bootstrap-prjct/locations/northamerica-northeast2/keyRings/pci-ring-tor/cryptoKeys/pci-key-tor"
}
bucket_regions       = {
  "northamerica-northeast1" = "northamerica-northeast1"
  "northamerica-northeast2" = "northamerica-northeast2"
}
labels               = {
  environment = "prod"
}
versioning_enabled   = true