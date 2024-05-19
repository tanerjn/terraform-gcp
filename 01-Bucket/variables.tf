# variables.tf

variable "project_id" {
  description = "project-id"
  type        = string
}

variable "region" {
  description = "region-name"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}

variable "location" {
  description = "The GCS bucket location"
  type        = string
  default     = "US"  # Default to multi-region US
}
