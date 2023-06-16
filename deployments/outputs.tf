# Description: Outputs for the deployment

output "PROJECT_ID" {
  value       = data.google_project.project.name
  description = "Project ID to use in Auth action for GCP in GitHub."
}

output "IDENTITY_PROVIDER" {
  value       = google_iam_workload_identity_pool_provider.ci_provider.name
  description = "Provider ID to use in Auth action for GCP in GitHub."
}

output "CI_SERVICE_ACCOUNT" {
  value       = google_service_account.ci_sa.email
  description = "Service account to use in GitHub Action for federated auth."
}

output "RUNNER_SERVICE_ACCOUNT" {
  value       = google_service_account.runner_sa.email
  description = "Service account to use for GCE VM runner."
}
