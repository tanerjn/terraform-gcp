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

resource "google_compute_subnetwork" "bastion_subnet" {
  name          = var.subnet_name_bastion
  ip_cidr_range = var.subnet_cidr_bastion
  region        = var.region
  network       = google_compute_network.vpc_network.id
}


resource "google_compute_subnetwork" "db_subnet" {
  name          = var.subnet_name_db
  ip_cidr_range = var.subnet_cidr_db
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "compute_subnet" {
  name          = var.subnet_name_compute
  ip_cidr_range = var.subnet_cidr_compute
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Define firewall rules
resource "google_compute_firewall" "bastion_firewall" {
  name    = "bastion-firewall"
  network = google_compute_network.vpc_network.name

  source_ranges = ["10.0.0.0/24", "192.168.1.0/24"]
  allow {
    protocol = "tcp"
    ports    = ["22"]


  }

  # Allow incoming HTTP and HTTPS traffic from any source
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_firewall" "db_firewall" {
  name    = "db-firewall"
  network = google_compute_network.vpc_network.name

  source_ranges = ["10.0.0.0/24", "192.168.1.0/24"]
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow incoming HTTP and HTTPS traffic from any source
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Allow all outgoing traffic to any destination
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "compute_firewall" {
  name    = "compute-firewall"
  network = google_compute_network.vpc_network.name

  source_ranges = ["10.0.0.0/24", "192.168.1.0/24"]
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow incoming HTTP and HTTPS traffic from any source
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Deny all incoming traffic from any source
  allow {
    protocol = "all" # -1 indicates all protocols
  }

  # Allow all outgoing traffic to any destination
  allow {
    protocol = "all"
  }
}


# Create bastion, db, compute instances in respective subnets
resource "google_compute_instance" "bastion_instance" {
  name         = "bastion-instance"
  machine_type = "f1-micro" # Change to your desired machine type
  zone         = "us-central1-a" # Change to your desired zone
   
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"  # Public image from GCP
      size  = "10"            
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.bastion_subnet.self_link
     // Attach the firewall rule to the instance
    access_config {
      // Optional: Reserve a static IP for the instance
      // This is not required but can be useful for certain setups
      // E.g., if you need a fixed IP for firewall rules or DNS purposes
      // Uncomment and provide the desired static IP address
      // nat_ip = "static-ip-address"

      // Attach the firewall rule to the network interface
      network_tier = "PREMIUM" // Optional: Change network tier if needed
    }
  }
  // Other instance configurations like boot disk, metadata, etc.
}

resource "google_compute_instance" "db_instance" {
  name         = "db-instance"
  machine_type = "f1-micro" # Change to your desired machine type
  zone         = "us-central1-b" # Change to your desired zone
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"  # Public image from GCP
      size  = "10"           
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.db_subnet.self_link
 // Attach the firewall rule to the instance
    access_config {
      // Optional: Reserve a static IP for the instance
      // This is not required but can be useful for certain setups
      // E.g., if you need a fixed IP for firewall rules or DNS purposes
      // Uncomment and provide the desired static IP address
      // nat_ip = "static-ip-address"

      // Attach the firewall rule to the network interface
      network_tier = "PREMIUM" // Optional: Change network tier if needed
    }
  }
  // Other instance configurations like boot disk, metadata, etc.
}

resource "google_compute_instance" "compute_instance" {
  name         = "compute-instance"
  machine_type = "f1-micro" # Change to your desired machine type
  zone         = "us-central1-c" # Change to your desired zone

    boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"  # Public image from GCP
      size  = "10"             
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.compute_subnet.self_link
   // Attach the firewall rule to the instance
    access_config {
      // Optional: Reserve a static IP for the instance
      // This is not required but can be useful for certain setups
      // E.g., if you need a fixed IP for firewall rules or DNS purposes
      // Uncomment and provide the desired static IP address
      // nat_ip = "static-ip-address"

      // Attach the firewall rule to the network interface
      network_tier = "PREMIUM" // Optional: Change network tier if needed
    }

  }
  // Other instance configurations like boot disk, metadata, etc.
}





