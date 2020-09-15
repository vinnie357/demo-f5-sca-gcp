# enable secret manager api
#resource google_project_service secretmanager {
#  service  = "secretmanager.googleapis.com"
#}
# 
# random password when admin password unset DEMO ONLY
#
resource random_password password {
  length           = 16
  special          = true
  override_special = " #%*+,-./:=?@[]^_~"
}
# nginx
# create secret
resource google_secret_manager_secret nginx-secret {
  secret_id = "nginx-secret"
  labels = {
    label = "nginx"
  }

  replication {
    automatic = true
  }
}
# create secret version
resource google_secret_manager_secret_version nginx-secret {
  depends_on  = [google_secret_manager_secret.nginx-secret]
  secret      = google_secret_manager_secret.nginx-secret.id
  secret_data = <<-EOF
  {
  "cert":"${var.nginxCert}",
  "key": "${var.nginxKey}",
  "cuser": "${var.controllerAccount}",
  "cpass": "${var.controllerPassword}"
  }
  EOF
}
# controller
# create secret
resource google_secret_manager_secret controller-secret {
  secret_id = "controller-secret"
  labels = {
    label = "controller"
  }

  replication {
    automatic = true
  }
}
# create secret version
resource google_secret_manager_secret_version controller-secret {
  depends_on  = [google_secret_manager_secret.controller-secret]
  secret      = google_secret_manager_secret.controller-secret.id
  secret_data = <<-EOF
  {
  "license": ${jsonencode(var.controllerLicense)},
  "user": "${var.controllerAccount}",
  "pass": "${var.controllerPassword}",
  "dbpass": "${var.dbPass}",
  "dbuser": "${var.dbUser}"
  }
  EOF
}
# bigip
# create secret
resource google_secret_manager_secret bigip-secret {
  secret_id = "bigip-secret"
  labels = {
    label = "bigip"
  }

  replication {
    automatic = true
  }
}
# create secret version
resource google_secret_manager_secret_version bigip-secret {
  depends_on  = [google_secret_manager_secret.bigip-secret]
  secret      = google_secret_manager_secret.bigip-secret.id
  secret_data = <<-EOF
  {
  "pass": "${var.adminPassword != "" ? var.adminPassword : random_password.password.result}",
  "bigiqPass": "${var.dbPass}"
  }
  EOF
}