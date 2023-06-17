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

variable "zone" {
  description = "Deployment zone in the region (zone)"
  default     = "c"
  type        = string
  nullable    = false
}

variable "vms" {
  description = "Managed instance group size (MIG: 3)"
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
  description = "GCE machine type (e.g. e2-medium)"
  default     = "e2-medium"
  type        = string
  nullable    = false
}

variable "token" {
  description = "GitHub Personal Access Token"
  type        = string
  nullable    = false
}
