source_tags = ["source-tag1", "source-tag2", "source-tag3"]
target_tags = ["target-tag1", "target-tag2", "target-tag3"]
ports = ["8000", "8080", "80"]
network_name = "my-network"
network_project = "nlb-network"
health_check_tcp = {
  type                = "tcp"
  check_interval_sec  = 10
  healthy_threshold   = 3
  timeout_sec         = 5
  unhealthy_threshold = 2
  response            = "200"
  proxy_header        = "NONE"
  port                = 80
  port_name           = "http"
  request             = "GET"
  request_path        = "/health"
  host                = "example.com"
  enable_log          = true
}

health_check_http = {
  type                = "http"
  check_interval_sec  = 10
  healthy_threshold   = 3
  timeout_sec         = 5
  unhealthy_threshold = 2
  response            = "200"
  proxy_header        = "NONE"
  port                = 8080
  port_name           = "http"
  request             = "GET"
  request_path        = "/health"
  host                = "example.com"
  enable_log          = true
}

health_check_https = {
  type                = "https"
  check_interval_sec  = 10
  healthy_threshold   = 3
  timeout_sec         = 5
  unhealthy_threshold = 2
  response            = "200"
  proxy_header        = "NONE"
  port                = 8080
  port_name           = "http"
  request             = "GET"
  request_path        = "/health"
  host                = "example.com"
  enable_log          = true
}


session_affinity = "NONE"