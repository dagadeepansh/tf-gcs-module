variable "bucket_name_prefix" {
  description = "Prefix for the bucket names. Names will be '<region>.<prefix>' (e.g., 'Toronto.scotiabank-pci-data')."
  type        = string
  default     = "pci-data"
}

variable "bucket_regions" {
  description = "Map of logical region names to Google Cloud region names."
  type        = map(string)
  default = {
    "Toronto"   = "northamerica-northeast1"
    "Montreal"  = "northamerica-northeast2"
    "Virginia"  = "us-east4"
    "mexico"    = "us-central1"
    "LATAM"    = "southamerica-east1"
  }
}

variable "kms_key_names" {
  description = "Map of region names to CMEK key names. The CMEK keys must already exist in the corresponding regions."
  type        = map(string)
}

variable "versioning_enabled" {
  description = "Enable versioning for the buckets."
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to the buckets."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment (e.g., 'prod', 'nonprod')."
  type        = string
  default     = "prod"
}

variable "organization_id" {
  description = "The organization ID."
  type = string
  default = "514831531729"
}

variable "project_id" {
  description = "The ID of the Google Cloud project where all buckets will be created."
  type        = string
  default     = "bootstrap-prjct"
}

variable "region" {
  description = "The default region for the Google Cloud provider."
  type        = string
  default     = "northamerica-northeast1"
}