# main.tf

# Specify the Terraform version
terraform {
  required_version = ">= 0.13"
}

# Configure the GCP provider
provider "google" {
  project     = "genuine-rope-423613-a9"      # Replace with your GCP project ID
  region      = var.region              # Replace with your preferred region
  credentials = file("~/.ssh/gcp/genuine-rope-423613-a9-2622e3b947a2.json")  
}

resource "google_storage_bucket" "example" {
  name                        = var.bucket_name
  location                    = var.location
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = {
    name        = "mybucket"
    environment = "dev"
  }
}

