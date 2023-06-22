# Description: List of variables which can be provided ar runtime to override the specified defaults 

variable "project" {
  description = "GCP Project ID"
  type        = string
  nullable    = false
}

variable "name" {
  description = "Base name to derive everythign else from"
  default     = "grunner"
  type        = string
}

variable "region" {
  description = "Deployment region (us-west1)"
  default     = "us-west1"
  type        = string
}

variable "vms" {
  description = "Managed instance group size (default: 4)"
  default     = 4
  type        = number
}

variable "repo" {
  description = "GitHub Repo (owner/repo)"
  type        = string
  nullable    = false
}

variable "machine" {
  description = "GCE machine type (default: e2-medium)"
  default     = "e2-medium"
  type        = string
}

variable "scopes" {
  description = "GCE machine scopes (default: cloud-platform)"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "size" {
  description = "GCE machine size in GBs (default: 10GB)"
  default     = 10
  type        = number
}

variable "image" {
  description = "GCE machine image (default: ubuntu-2204-jammy-v20230616)"
  default     = "ubuntu-2204-jammy-v20230616"
  type        = string
}

variable "disk" {
  description = "The type of disk to use (default: pd-ssd)"
  default     = "pd-ssd"
  type        = string
}

variable "token" {
  description = "GitHub Personal Access Token"
  type        = string
  nullable    = false
}

variable "network" {
  description = "CIDR block to allocate for the VM network (default: 10.10.0.0/16)"
  type        = string
  default     = "10.10.0.0/16"
}
