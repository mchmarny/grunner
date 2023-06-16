locals {
  # List of roles that will be assigned to the runner service account
  runner_roles = toset([
    "roles/iam.serviceAccountTokenCreator",
    "roles/monitoring.metricWriter",
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

# VM template for runner
resource "google_compute_instance_template" "runner_template" {
  name        = "${var.name}-template"
  description = "Used to create runner instances."

  tags = ["${var.name}"]

  labels = {
    environment = "test"
    stack       = "github"
    component   = "runner"
  }

  machine_type = var.machine
  region       = var.location

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  disk {
    disk_type    = "pd-standard"
    source_image = "ubuntu-2204-jammy-v20230616"
    disk_size_gb = 10 # TODO: Parameterize
  }

  network_interface {
    network = "default"
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    email  = google_service_account.runner_sa.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = "${file("../scripts/startup")}"

  metadata = {
    enable-guest-attributes = "true"
    enable-osconfig         = "true"
  }
}

// Rundom name to force rolling updates when something changes in the template
resource "google_compute_region_instance_group_manager" "mig" {
  name               = "${var.name}-mig"
  base_instance_name = var.name
  region             = var.location
  target_size        = var.vms

  version {
    instance_template = google_compute_instance_template.runner_template.self_link_unique
  }

  timeouts {
    create = "15m"
    update = "15m"
  }

  lifecycle {
    create_before_destroy = true
  }
}