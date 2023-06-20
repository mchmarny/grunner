# Description: Creates a Google Artifact Registry for the project

# Artifact Registry
resource "google_artifact_registry_repository" "registry" {
  provider      = google-beta
  project       = var.project
  description   = "${var.name} artifacts registry"
  location      = var.region
  repository_id = var.name
  format        = "DOCKER"
}

# Role binding to allow publisher to publish images
resource "google_artifact_registry_repository_iam_member" "registry_role_binding" {
  provider   = google-beta
  project    = var.project
  location   = var.region
  repository = google_artifact_registry_repository.registry.name
  role       = "roles/artifactregistry.repoAdmin"
  member     = "serviceAccount:${google_service_account.ci_sa.email}"
}
