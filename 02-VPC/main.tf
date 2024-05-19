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

resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
