# nginx
resource google_service_account gce-nginx-sa {
  account_id   = "gce-nginx-sa"
  display_name = "nginx service account for secret access"
}
# add service account read permissions to secret
resource google_secret_manager_secret_iam_member gce-nginx-sa-iam {
  depends_on = [google_service_account.gce-nginx-sa]
  secret_id  = google_secret_manager_secret.nginx-secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.gce-nginx-sa.email}"
}
resource google_project_iam_member project {
  project = var.gcpProjectId
  role    = "roles/compute.networkViewer"
  member  = "serviceAccount:${google_service_account.gce-nginx-sa.email}"
}
# controller
resource google_service_account gce-controller-sa {
  account_id   = "gce-controller-sa"
  display_name = "controller service account for secret access"
}
# add service account read permissions to secret
resource google_secret_manager_secret_iam_member gce-controller-sa-iam {
  depends_on = [google_service_account.gce-controller-sa]
  secret_id  = google_secret_manager_secret.controller-secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.gce-controller-sa.email}"
}

resource google_storage_bucket_iam_binding controller-bucket-role {
  bucket = var.controllerBucket
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_service_account.gce-controller-sa.email}"
  ]
}
# bigip
resource google_service_account gce-bigip-sa {
  account_id   = "gce-bigip-sa"
  display_name = "bigip service account for secret access"
}
# add service account read permissions to secret
resource google_secret_manager_secret_iam_member gce-bigip-sa-iam {
  depends_on = [google_service_account.gce-bigip-sa]
  secret_id  = google_secret_manager_secret.bigip-secret.secret_id
  role       = "roles/secretmanager.secretAccessor"
  member     = "serviceAccount:${google_service_account.gce-bigip-sa.email}"
}

resource google_storage_bucket_iam_binding bigip-bucket-role {
  bucket = google_storage_bucket.bigip-ha.name
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${google_service_account.gce-controller-sa.email}"
  ]
}