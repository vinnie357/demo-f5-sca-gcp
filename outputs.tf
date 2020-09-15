# Outputs
# bigip
output "f5vm01_ext_selfip" { value = google_compute_instance.f5vm01.network_interface.0.network_ip }
output "f5vm01_ext_selfip_pip" { value = google_compute_instance.f5vm01.network_interface.0.access_config.0.nat_ip }
output "f5vm01_mgmt_ip" { value = google_compute_instance.f5vm01.network_interface.1.network_ip }
output "f5vm01_mgmt_pip" { value = google_compute_instance.f5vm01.network_interface.1.access_config.0.nat_ip }
output "f5vm01_mgmt_pip_url" { value = "https://${google_compute_instance.f5vm01.network_interface.1.access_config.0.nat_ip}" }
output "f5vm01_mgmt_name" { value = google_compute_instance.f5vm01.name }
output "f5vm02_ext_selfip" { value = google_compute_instance.f5vm02.network_interface.0.network_ip }
output "f5vm02_ext_selfip_pip" { value = google_compute_instance.f5vm02.network_interface.0.access_config.0.nat_ip }
output "f5vm02_mgmt_ip" { value = google_compute_instance.f5vm02.network_interface.1.network_ip }
output "f5vm02_mgmt_pip" { value = google_compute_instance.f5vm02.network_interface.1.access_config.0.nat_ip }
output "f5vm02_mgmt_pip_url" { value = "https://${google_compute_instance.f5vm02.network_interface.1.access_config.0.nat_ip}" }
output "f5vm02_mgmt_name" { value = google_compute_instance.f5vm02.name }
output "public_vip" { value = google_compute_forwarding_rule.vip1.ip_address }
output "public_vip_url" { value = "https://${google_compute_forwarding_rule.vip1.ip_address}" }
# # nginx
# output "nginx_pip" { value = google_compute_instance.f5vm01.network_interface.0.network_ip }
# # controller
# output "controller_pip" { value = google_compute_instance.f5vm01.network_interface.0.network_ip }
# # consul
# output "consul_pip" { value = google_compute_instance.f5vm01.network_interface.0.network_ip }