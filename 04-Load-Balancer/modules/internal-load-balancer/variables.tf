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

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "my-vpc-network"
}

variable "subnet_name_bastion" {
  description = "The name of the subnet"
  type        = string
  default     = "bastion_subnet"
}

variable "subnet_name_db" {
  description = "The name of the subnet"
  type        = string
  default     = "db_subnet"
}

variable "subnet_name_compute" {
  description = "The name of the subnet"
  type        = string
  default     = "bastion_compute"
}

variable "subnet_cidr_bastion" {
  description = "The CIDR range of the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_cidr_db" {
  description = "The CIDR range of the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_compute" {
  description = "The CIDR range of the subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_names" {
  description = "List of instance names to be used as backends."
  type        = list(string)
  default     = ["instance-bastion", "instance-db", "instance-compute"]
  validation {
    condition     = length(var.instance_names) >= 3
    error_message = "The instance_names list must have at least three elements."
  }
}

variable "instance_self_links" {
  description = "List of instance self-links to be manually added to the instance group."
  type        = list(string)
  default     = []
}

variable "instance_zone" {
  description = "The zone where instances will be created."
  type        = string
  default     = "us-central1-b"
}
