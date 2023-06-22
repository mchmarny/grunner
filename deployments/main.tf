# Description: This file contains the Terraform code to enable the required GCP APIs for the project

# List of GCP APIs to enable in this project
locals {
  services = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "monitoring.googleapis.com",
    "networkmanagement.googleapis.com",
    "secretmanager.googleapis.com",
    "servicecontrol.googleapis.com",
    "servicemanagement.googleapis.com",
    "vpcaccess.googleapis.com",
  ]
}

# Data source to access GCP project metadata 
data "google_project" "project" {}

# Enable the required GCP APIs
resource "google_project_service" "services" {
  for_each = toset(local.services)

  project = var.project
  service = each.value

  disable_on_destroy = false
}

resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
  numeric = true
}