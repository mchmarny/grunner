# This is a list of roles that will be assigned to the GitHub federted user
locals {
  # List of roles that will be assigned to the GitHub federted user
  ci_roles = toset([
    "roles/artifactregistry.writer",
    "roles/artifactregistry.reader",
    "roles/viewer",
  ])
}

# Service account to be used for federated auth to publish to GCR (existing)
resource "google_service_account" "ci_sa" {
  account_id   = "${var.name}-ci-sa"
  display_name = "Service Account impersonated in GitHub Actions"
}

# IAM policy bindings to the service account resources created by GitHub identify
resource "google_project_iam_member" "ci_role_bindings" {
  for_each = local.ci_roles
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.ci_sa.email}"
}

# Identiy pool for GitHub action based identity's access to Google Cloud resources
resource "google_iam_workload_identity_pool" "id_pool" {
  provider                  = google-beta
  workload_identity_pool_id = "${var.name}-id-pool-${random_string.id.result}"
}

# Configuration for GitHub identiy provider
resource "google_iam_workload_identity_pool_provider" "pool_provider" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.id_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.aud"        = "assertion.aud"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri        = "https://token.actions.githubusercontent.com"
    allowed_audiences = []
  }
}

# IAM policy bindings to the service account resources created by GitHub identify
resource "google_service_account_iam_member" "pool_impersonation" {
  provider           = google-beta
  service_account_id = google_service_account.ci_sa.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.id_pool.name}/attribute.repository/${var.repo}"
}
