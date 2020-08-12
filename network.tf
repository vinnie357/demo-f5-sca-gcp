# networks
# vpc
resource google_compute_network vpc_network_mgmt {
  name                    = "terraform-network-mgmt-example"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_mgmt_sub {
  name          = "mgmt-sub-example"
  ip_cidr_range = "10.0.10.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network_mgmt.self_link

}
resource google_compute_network vpc_network_int {
  name                    = "terraform-network-int-example"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_int_sub {
  name          = "int-sub-example"
  ip_cidr_range = "10.0.20.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network_int.self_link

}
resource google_compute_network vpc_network_ext {
  name                    = "terraform-network-ext-example"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}
resource google_compute_subnetwork vpc_network_ext_sub {
  name          = "ext-sub-example"
  ip_cidr_range = "10.0.30.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network_ext.self_link

}