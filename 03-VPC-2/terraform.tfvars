# terraform.tfvars

project_id  = "genuine-rope-423613-a9"  # Replace with your GCP project ID
region      = "us-central1"
subnet_name_bastion  = "bastion-subnet"
subnet_name_db  = "bastion-db"
subnet_name_compute  = "bastion-compute"
subnet_cidr_bastion  = "10.0.0.0/24"
subnet_cidr_db  = "10.0.1.0/24"
subnet_cidr_compute  = "10.0.2.0/24"
