# template
# Setup Onboarding scripts
data template_file nginx_onboard {
  template = file("${path.module}/templates/nginx/startup.sh.tpl")

  vars = {
    controllerAddress = "12134"
  }
}
resource google_compute_instance_template nginx-template {
  name_prefix = "nginx-template-"
  description = "This template is used to create runner server instances."

  instance_description = "nginx"
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
    startup-script = data.template_file.nginx_onboard.rendered
    #shutdown-script = "${file("${path.module}/templates/nginx/shutdown.sh")}"
  }
  service_account {
    email  = google_service_account.gce-nginx-sa.email
    scopes = ["cloud-platform"]
  }
}

# instance group 0
resource google_compute_instance_group_manager nginx-group {
  depends_on         = [google_container_cluster.primary, google_compute_instance_group_manager.controller-group]
  name               = "${var.prefix}-nginx-instance-group-manager"
  base_instance_name = "${var.prefix}-nginx"
  zone               = var.gcpZone
  target_size        = 1
  version {
    instance_template = google_compute_instance_template.nginx-template.id
  }
  # wait for gke cluster
  timeouts {
    create = "15m"
  }
}
# instance group 1
resource google_compute_instance_group_manager nginx-group-1 {
  depends_on         = [google_container_cluster.primary, google_compute_instance_group_manager.controller-group]
  name               = "${var.prefix}-nginx-instance-group-manager-1"
  base_instance_name = "${var.prefix}-nginx"
  zone               = "${var.gcpRegion}-c"
  target_size        = 1
  version {
    instance_template = google_compute_instance_template.nginx-template.id
  }
  # wait for gke cluster
  timeouts {
    create = "15m"
  }
}