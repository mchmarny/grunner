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
  nullable    = false
}

variable "region" {
  description = "Deployment region (us-west1)"
  default     = "us-west1"
  type        = string
  nullable    = false
}

variable "vms" {
  description = "Managed instance group size (default: 3)"
  default     = 3
  type        = number
  nullable    = false
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
  nullable    = false
}

variable "scopes" {
  description = "GCE machine scopes (default: cloud-platform)"
  type        = list(string)
  default     = ["cloud-platform"]
  nullable    = false
}

variable "size" {
  description = "GCE machine size in GBs (default: 10GB)"
  default     = 10
  type        = number
  nullable    = false
}

variable "image" {
  description = "GCE machine image (default: ubuntu-2204-jammy-v20230616)"
  default     = "ubuntu-2204-jammy-v20230616"
  type        = string
  nullable    = false
}

variable "disk" {
  description = "The type of disk to use (default: pd-ssd)"
  default     = "pd-ssd"
  type        = string
  nullable    = false
}

variable "token" {
  description = "GitHub Personal Access Token"
  type        = string
  nullable    = false
}
