resource "google_compute_instance_template" "runner_template" {
  name         = "${var.name}-template"
  machine_type = var.machine
  region       = var.region

  instance_description = "${var.name} vm"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  # TODO: Parameterize the disk
  disk {
    disk_type    = "pd-ssd"
    source_image = var.image
    disk_size_gb = var.size
    boot         = true
    auto_delete  = true
  }

  // TODO: Put it into a VPC
  network_interface {
    network = data.google_compute_network.default.self_link
    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = google_service_account.runner_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script          = file("../scripts/startup")
    shutdown-script         = file("../scripts/shutdown")
    enable-guest-attributes = "true"
    enable-osconfig         = "true"
  }

  tags = ["${var.name}"]

  labels = {
    environment = "test"
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