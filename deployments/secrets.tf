# API Key Secret 
resource "google_secret_manager_secret" "runner_secret" {
  secret_id = var.name

  replication {
    automatic = true
  }
}

data "template_file" "config" {
  template = file("terraform.tfvars")
}

# API Key Secret version (holds data)
resource "google_secret_manager_secret_version" "runner_secret_version" {
  secret = google_secret_manager_secret.runner_secret.name

  secret_data = data.template_file.config.rendered
}