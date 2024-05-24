# variables.tf

variable "project_id" {
  description = "project-id"
  type        = string
  default     = "genuine-rope-423613-a9"
}

variable "region" {
  description = "region"
  type        = string
  default     = "europe-west1"
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
  default     = "l7-ilb-network"
}

variable "subnet_proxy" {
  description = "address for proxy subnet"
  type        = string
  default     = "subnet_proxy"
}

variable "subnet_default" {
  description = "address for default subnet"
  type        = string
  default     = "subnet_default"
}

variable "subnet_cidr_proxy" {
  description = "The CIDR range of the proxy subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "subnet_cidr_default" {
  description = "The CIDR range of the default subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_names" {
  description = "List of instance names to be used as backends."
  type        = list(string)
  default     = ["l7-ilb-mig-template", "instance-test"]
}

variable "instance_links" {
  description = "List of instance self-links to be manually added to the instance group."
  type        = list(string)
  default     = []
}

variable "instance_zone" {
  description = "The zone where instances will be created."
  type        = string
  default     = "us-central1-c"
}
