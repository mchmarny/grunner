locals {
  # List of roles that will be assigned to the runner service account
  runner_roles = toset([
    "roles/compute.networkUser",
    "roles/iam.serviceAccountTokenCreator",
    "roles/iam.serviceAccountUser",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/secretmanager.secretAccessor",
    "roles/stackdriver.resourceMetadata.writer",
  ])
}

# Service account to be used run jobs in GCE VMs
resource "google_service_account" "runner_sa" {
  account_id   = "${var.name}-sa"
  display_name = "Service Account executing GCE VMs"
}

# Role binding for runner
resource "google_project_iam_member" "runner_role_bindings" {
  for_each = local.runner_roles
  project  = var.project
  role     = each.value
  member   = "serviceAccount:${google_service_account.runner_sa.email}"
}

# Policy to allow access to secrets 
data "google_iam_policy" "secret_reader" {
  binding {
    role = "roles/secretmanager.secretAccessor"
    members = [
      "serviceAccount:${google_service_account.runner_sa.email}",
    ]
  }
}

# Policy to allow access to secrets
resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.runner_secret.project
  secret_id   = google_secret_manager_secret.runner_secret.secret_id
  policy_data = data.google_iam_policy.secret_reader.policy_data
}

# Binding to policy to allow access to secrets
resource "google_secret_manager_secret_iam_binding" "binding" {
  project   = google_secret_manager_secret.runner_secret.project
  secret_id = google_secret_manager_secret.runner_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:${google_service_account.runner_sa.email}",
  ]
}