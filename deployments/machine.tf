resource "random_string" "id" {
  length = 4
  special = false
  upper = false
  numeric = true
}

resource "google_compute_instance_template" "runner_template" {
  name         = "${var.name}-template-${random_string.id.result}"
  machine_type = var.machine
  region       = var.region

  instance_description = "${var.name} vm"
  can_ip_forward       = false

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
    network = data.google_compute_network.default.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }

  service_account {
    email  = google_service_account.runner_sa.email
    scopes = var.scopes
  }

  metadata = {
    startup-script          = file("../scripts/vm-startup")
    shutdown-script         = file("../scripts/vm-shutdown")
    enable-guest-attributes = "true"
    enable-osconfig         = "true"
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
}


resource "google_compute_region_instance_group_manager" "mig" {
  name               = "${var.name}-mig"
  region             = var.region
  base_instance_name = var.name
  target_size        = var.vms

  version {
    name              = "${var.name} template"
    instance_template = google_compute_instance_template.runner_template.self_link_unique
  }
}