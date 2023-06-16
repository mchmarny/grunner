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
  region       = var.region

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
  region             = var.region
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