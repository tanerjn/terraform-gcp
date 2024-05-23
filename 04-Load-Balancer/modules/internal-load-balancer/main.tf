# main.tf

terraform {
  required_version = ">= 0.13"
}

provider "google" {
  project     = "genuine-rope-423613-a9"      
  region      = var.region           
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

resource "google_compute_firewall" "bastion_firewall" {
  name    = "bastion-firewall"
  network = google_compute_network.vpc_network.name
  source_ranges = ["10.0.0.0/24", "192.168.1.0/24"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
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
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
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
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "all" # -1 indicates all protocols
  }
  allow {
    protocol = "all"
  }
}

# Create bastion, db, compute instances in respective subnets
resource "google_compute_instance" "bastion_instance" {
  name         = var.instance_names[0]
  machine_type = "f1-micro" 
  zone         = var.instance_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10" 
      size  = "10"            
    }
  }
  network_interface {
    network = var.network_name
    subnetwork = google_compute_subnetwork.bastion_subnet.self_link
    access_config {
      // nat_ip = "static-ip-address"
      // Attach the firewall rule to the network interface
      network_tier = "PREMIUM"
    }
  }
}

resource "google_compute_instance" "db_instance" {
  name         = var.instance_names[1]
  machine_type = "f1-micro" 
  zone         = var.instance_zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"  
      size  = "10"           
    }
  }
  network_interface {
    network = var.network_name
    subnetwork = google_compute_subnetwork.db_subnet.self_link
    access_config {
      // nat_ip = "static-ip-address"
      // Attach the firewall rule to the network interface
      network_tier = "PREMIUM" 
    }
  }
}

resource "google_compute_instance" "compute_instance" {
  name         = var.instance_names[2]
  machine_type = "f1-micro"
  zone         = "us-central1-c" 
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10" 
      size  = "10"             
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.compute_subnet.self_link
    access_config {
      // nat_ip = "static-ip-address"
      network_tier = "PREMIUM" 
    }
  }
}

resource "google_compute_instance_group" "default" {
  name        = "ilb-instance-group"
  zone        = var.instance_zone
  instances   = var.instance_self_links
  named_port {
    name = "http"
    port = 80
  }
}








