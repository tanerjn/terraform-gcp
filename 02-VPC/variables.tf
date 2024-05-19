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

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "my-subnet"
}

variable "subnet_cidr" {
  description = "The CIDR range of the subnet"
  type        = string
  default     = "10.0.0.0/24"
}
