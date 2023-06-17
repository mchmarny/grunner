# Description: This file contains the provider configuration for the project.

# Configure the Google Cloud provider
terraform {
  required_version = "~> 1.4"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.69"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.69"
    }
  }
}

# Configure provider.
provider "google" {
  project = var.project
}

# Configure beta provider.
provider "google-beta" {
  project = var.project
}