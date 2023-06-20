# Description: Outputs for the deployment

output "PROJECT_ID" {
  value       = data.google_project.project.name
  description = "Project ID to use in Auth action for GCP in GitHub."
}

output "RUNNER_SERVICE_ACCOUNT" {
  value       = google_service_account.runner_sa.email
  description = "Service account to use for GCE VM runner."
}

output "REGISTRY_URI" {
  value       = "${google_artifact_registry_repository.registry.location}-docker.pkg.dev/${data.google_project.project.name}/${google_artifact_registry_repository.registry.name}"
  description = "Artifact Registry URI."
}

output "CI_SERVICE_ACCOUNT" {
  value       = google_service_account.ci_sa.email
  description = "Service account to use in GitHub Action for federated auth."
}

output "CI_IDENTITY_PROVIDER" {
  value       = google_iam_workload_identity_pool_provider.github_provider.name
  description = "Provider ID to use in Auth action for GCP in GitHub."
}
