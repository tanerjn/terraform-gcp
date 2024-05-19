# main.tf

# Specify the Terraform version
terraform {
  required_version = ">= 0.13"
}

# Configure the GCP provider
provider "google" {
  project     = "genuine-rope-423613-a9"      # Replace with your GCP project ID
  region      = "us-central1"              # Replace with your preferred region
  credentials = file("~/.ssh/gcp/genuine-rope-423613-a9-2622e3b947a2.json")  
}

# Define a resource: A simple Compute Engine instance
resource "google_compute_instance" "vm_instance" {
  name         = "example-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"           # Replace with your preferred zone

  # Specify the boot disk image
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  # Specify a network interface with a default network
  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP
    }
  }

  # Metadata for SSH access
  metadata = {
    ssh-keys = "genuine-rope-423613-a9-2622e3b947a2.json:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFnAH8lYitDbOe0tffkgTUN+K23N6Tm1E/WqlDlkIhGlEC4d7zFfiiEF13wgoGm3IFwNOKc1pSpdUdhJvVlVEUr8uLzqVdJJeZNcHGntNZ1w8i6gK4kM1NDJ3q35hi71fmWLTtbk2V1Ss/YarQCdWVWtVBTE8o8vyG5Ic303z7XCFvY5d2gAh/Q4Dh4ho7eIQ0PUzJ2tb9YPPL8BEXzWilDVMj536/lApTzc6RJ9gLiNzN/W7oKHbhyrTXsQvo0ZEhwCEbIkYKdPLdmtn7tQ203omEggACYc4jxK0mYgZMYNZvoCPWwJ+vcOuropiviVnAyN4AYjCGjGxe+j+rv0R/ taner@mbp"
  }
}

# Output the instance's IP address
output "instance_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

