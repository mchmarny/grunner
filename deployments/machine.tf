resource "google_compute_instance_template" "runner" {
  provider       = google-beta
  name_prefix    = "runner-"
  machine_type   = var.machine
  region         = var.region
  can_ip_forward = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    min_node_cpus       = 0
    provisioning_model  = "STANDARD"
  }

  disk {
    disk_type    = var.disk
    source_image = var.image
    disk_size_gb = var.size
    boot         = true
    auto_delete  = true
    labels = {
      component = "runner"
    }
    resource_policies = []
  }

  network_interface {
    subnetwork_project = var.project
    subnetwork         = google_compute_subnetwork.runners.id
  }

  service_account {
    email  = google_service_account.runner_sa.email
    scopes = var.scopes
  }

  metadata = {
    startup-script               = file("../scripts/vm-startup")
    shutdown-script              = file("../scripts/vm-shutdown")
    google-logging-enabled       = "true"
    google-logging-use-fluentbit = "true"
    google-monitoring-enabled    = "true"
  }

  tags = ["${var.name}"]

  labels = {
    environment = "demo"
    stack       = "github"
    component   = "runner"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    google_project_service.services["compute.googleapis.com"],
  ]
}


resource "google_compute_region_instance_group_manager" "mig" {
  provider           = google-beta
  name               = "${var.name}-mig"
  region             = var.region
  base_instance_name = var.name
  target_size        = var.vms

  version {
    name              = "${var.name} template"
    instance_template = google_compute_instance_template.runner.self_link_unique
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health_check.id
    initial_delay_sec = 30 # wait for SSH to be up
  }

  update_policy {
    type                           = "PROACTIVE"
    instance_redistribution_type   = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    replacement_method             = "RECREATE"
    max_surge_fixed                = 0
    max_unavailable_fixed          = 4
  }

  all_instances_config {}
}

resource "google_compute_health_check" "health_check" {
  provider = google-beta
  name     = "${var.name}-health-check"

  timeout_sec         = 5
  check_interval_sec  = 5
  unhealthy_threshold = 3

  tcp_health_check {
    port = "22"
  }

  log_config {
    enable = true
  }
}
