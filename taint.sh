#!/bin/bash
## nginx
# terraform taint google_compute_instance_group_manager.nginx-group
# terraform taint google_compute_instance_group_manager.nginx-group-1
## controller
# terraform taint google_compute_instance_group_manager.controller-group 
# ## consul
# terraform taint google_compute_instance_group_manager.consul-group
# ## bigip
# terraform taint google_compute_instance.f5vm01
# terraform taint google_compute_instance.f5vm02
# ## k8s
# terraform taint google_container_cluster.primary
# terraform taint google_container_node_pool.primary_preemptible_nodes
## apply
read -p "Press enter to continue"
terraform apply --auto-approve