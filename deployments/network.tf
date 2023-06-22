resource "google_compute_network" "runners" {
  name         = "runners-network"
  routing_mode = "GLOBAL"
  mtu          = "1500"

  auto_create_subnetworks = true

  depends_on = [
    google_project_service.services["compute.googleapis.com"],
  ]
}

resource "google_compute_subnetwork" "runners" {
  region        = var.region
  name          = "runners-subnet"
  ip_cidr_range = var.network
  network       = google_compute_network.runners.id

  private_ip_google_access = true
}

resource "google_compute_router" "runners" {
  name    = "runners-router"
  region  = google_compute_subnetwork.runners.region
  network = google_compute_network.runners.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "runners" {
  name   = "runners-nat"
  router = google_compute_router.runners.name
  region = google_compute_router.runners.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.runners.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_firewall" "egress" {
  name        = "runners-egress"
  network     = google_compute_network.runners.id
  direction   = "EGRESS"
  target_tags = ["${var.name}"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "ingress" {
  name          = "runners-ingress"
  network       = google_compute_network.runners.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.name}"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}