# The forwarding rule resource needs the self_link but the firewall rules only need the name.
# Using a data source here to access both self_link and name by looking up the network name.

provider "google" {
  project     = "genuine-rope-423613-a9"      
  region      = var.region           
  credentials = file("~/.ssh/gcp/genuine-rope-423613-a9-2622e3b947a2.json")  
}

resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnetwork
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.network.id
}

resource "google_compute_forwarding_rule" "default" {
  name                   = var.name
  region                 = var.region
  network                = google_compute_network.network.id
  subnetwork             = google_compute_subnetwork.subnet.id
  allow_global_access    = var.global_access
  load_balancing_scheme  = "INTERNAL"
  is_mirroring_collector = var.is_mirroring_collector
  backend_service        = google_compute_region_backend_service.default.id
  ip_address             = var.ip_address
  ip_protocol            = var.ip_protocol
  ports                  = var.ports
  all_ports              = var.all_ports
  service_label          = var.service_label
  labels                 = var.labels
}

resource "google_compute_region_backend_service" "default" {
  name = {
    "tcp"   = "${var.name}-with-tcp-hc",
    "http"  = "${var.name}-with-http-hc",
    "https" = "${var.name}-with-https-hc",
  }[var.health_check_tcp["type"]]
  region   = var.region
  protocol = var.ip_protocol
  network  = google_compute_network.network.id
  connection_draining_timeout_sec = var.connection_draining_timeout_sec
  session_affinity                = var.session_affinity
  health_checks = google_compute_health_check.tcp[*].id
}

resource "google_compute_health_check" "tcp" {
  count    = var.health_check_tcp["type"] == "tcp" ? 1 : 0
  name     = "${var.name}-hc-tcp"

  timeout_sec         = var.health_check_tcp["timeout_sec"]
  check_interval_sec  = var.health_check_tcp["check_interval_sec"]
  healthy_threshold   = var.health_check_tcp["healthy_threshold"]
  unhealthy_threshold = var.health_check_tcp["unhealthy_threshold"]

  tcp_health_check {
    port         = var.health_check_tcp["port"]
    request      = var.health_check_tcp["request"]
    response     = var.health_check_tcp["response"]
    port_name    = var.health_check_tcp["port_name"]
    proxy_header = var.health_check_tcp["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check_tcp["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_health_check" "http" {
  count    = var.health_check_http["type"] == "http" ? 1 : 0
  name     = "${var.name}-hc-http"

  timeout_sec         = var.health_check_http["timeout_sec"]
  check_interval_sec  = var.health_check_http["check_interval_sec"]
  healthy_threshold   = var.health_check_http["healthy_threshold"]
  unhealthy_threshold = var.health_check_http["unhealthy_threshold"]

  http_health_check {
    port         = var.health_check_http["port"]
    request_path = var.health_check_http["request_path"]
    host         = var.health_check_http["host"]
    response     = var.health_check_http["response"]
    port_name    = var.health_check_http["port_name"]
    proxy_header = var.health_check_http["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check_http["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_health_check" "https" {
  count    = var.health_check_https["type"] == "https" ? 1 : 0
  name     = "${var.name}-hc-https"

  timeout_sec         = var.health_check_https["timeout_sec"]
  check_interval_sec  = var.health_check_https["check_interval_sec"]
  healthy_threshold   = var.health_check_https["healthy_threshold"]
  unhealthy_threshold = var.health_check_https["unhealthy_threshold"]

  https_health_check {
    port         = var.health_check_https["port"]
    request_path = var.health_check_https["request_path"]
    host         = var.health_check_https["host"]
    response     = var.health_check_https["response"]
    port_name    = var.health_check_https["port_name"]
    proxy_header = var.health_check_https["proxy_header"]
  }

  dynamic "log_config" {
    for_each = var.health_check_https["enable_log"] ? [true] : []
    content {
      enable = true
    }
  }
}

resource "google_compute_firewall" "default-ilb-fw" {
  count   = var.create_backend_firewall ? 1 : 0
  name    = "${var.name}-ilb-fw"
  network = google_compute_network.network.name

  allow {
    protocol = lower(var.ip_protocol)
    ports    = var.ports
  }

  source_ranges           = var.source_ip_ranges
  source_tags             = var.source_tags
  source_service_accounts = var.source_service_accounts
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts

  dynamic "log_config" {
    for_each = var.firewall_enable_logging ? [true] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "default-hc" {
  count   = var.create_health_check_firewall ? 1 : 0
  name    = "${var.name}-hc"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = [var.health_check_tcp["port"]]
  }

  source_ranges           = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts

  dynamic "log_config" {
    for_each = var.firewall_enable_logging ? [true] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}