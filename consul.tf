# template

# Setup Onboarding scripts
data template_file consul_onboard {
  template = file("${path.module}/templates/consul/startup.sh.tpl")

  vars = {
    CONSUL_VERSION = "1.7.2"
    zone           = var.gcpZone
    project        = var.gcpProjectId
  }
}

resource google_compute_instance_template consul-template {
  name_prefix          = "consul-template-"
  description          = "This template is used to create runner server instances."
  tags                 = ["consul-demo"]
  instance_description = "consul"
  machine_type         = "n1-standard-4"
  can_ip_forward       = false

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-1804-lts"
    auto_delete  = true
    boot         = true
    type         = "pd-ssd"
  }
  network_interface {
    network    = google_compute_network.vpc_network_int.id
    subnetwork = google_compute_subnetwork.vpc_network_int_sub.id
    access_config {
    }
  }
  lifecycle {
    create_before_destroy = true
  }
  metadata = {
    startup-script = data.template_file.consul_onboard.rendered
    #shutdown-script = "${file("${path.module}/scripts/consul/shutdown.sh")}"
  }
  service_account {
    #email = google_service_account.consul-sa.email
    scopes = ["cloud-platform"]
  }
}

# instance group

resource google_compute_instance_group_manager consul-group {
  depends_on         = [google_container_cluster.primary]
  name               = "${var.prefix}-consul-instance-group-manager"
  base_instance_name = "${var.prefix}-consul"
  zone               = var.gcpZone
  target_size        = 3
  version {
    instance_template = google_compute_instance_template.consul-template.id
  }
  # wait for gke cluster
  timeouts {
    create = "15m"
  }
}