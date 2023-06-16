# VM template for runner
resource "random_id" "id" {
	  byte_length = 4
}

resource "google_compute_instance_template" "runner_template" {
  name        = "${var.name}-template-${random_id.id.hex}"
  machine_type = var.machine
  region       = var.region

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  # TODO: Parameterize the disk
  disk {
    disk_type    = "pd-ssd"
    source_image = "ubuntu-2204-jammy-v20230616"
    disk_size_gb = 10
    boot         = true
    auto_delete  = true
  }

  network_interface {
    network = data.google_compute_network.default.self_link
    access_config {
      // Ephemeral IP
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
}