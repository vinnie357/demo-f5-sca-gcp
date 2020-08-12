# admin
variable adminSrcAddr {
  description = "admin src address in cidr"
}
variable adminAccount {
  description = "admin account"
}
variable adminPass {
  description = "admin password"
}
# GKE
variable projectPrefix {
  description = "prefix for resources"
}
variable gcpZone {
  description = "zone where gke is deployed"
}
variable gcpRegion {
  description = "region where gke is deployed"
}
variable gcpProjectId {
  description = "gcp project id"
}
#https://cloud.google.com/kubernetes-engine/docs/release-notes-regular
#https://cloud.google.com/kubernetes-engine/versioning-and-upgrades
#gcloud container get-server-config --region us-east1
variable gkeVersion {
  default = "1.16.13-gke.1"
}

variable podCidr {
  description = "k8s pod cidr"
  default     = "10.56.0.0/14"
}

# consul

# nginx
variable nginxKey {
  description = "key for nginxplus"
}
variable nginxCert {
  description = "cert for nginxplus"
}
# controller
variable controllerLicense {
  description = "license for controller"
  default     = "none"
}
variable controllerBucket {
  description = "name of controller installer bucket"
  default     = "none"
}
variable controllerAccount {
  description = "name of controller admin account"
  default     = "admin@nginx-gcp.internal"
}
variable controllerPass {
  description = "pass of controller admin account"
  default     = "admin123!"
}
variable dbPass {
  description = "pass of controller admin account"
  default     = "naaspassword"
}
variable dbUser {
  description = "pass of controller admin account"
  default     = "naas"
}

# bigip

# Google Environment
variable svc_acct {}
variable privateKeyId {}
variable ksecret {}
variable gcp_project_id {}
variable gcp_region {}
variable gcp_zone {}
variable prefix {}

# NETWORK
variable extVpc { default = "terraform-network-ext-example" }
variable intVpc { default = "terraform-network-int-example" }
variable mgmtVpc { default = "terraform-network-mgmt-example" }
variable extSubnet { default = "ext-sub-example" }
variable intSubnet { default = "int-sub-example" }
variable mgmtSubnet { default = "mgmt-sub-example" }
variable alias_ip_range { default = "10.0.30.100/32" }
variable managed_route1 { default = "192.0.2.0/24" } # adjust to your environment

# BIGIP Image
variable bigipMachineType { default = "n1-standard-8" }
variable image_name { default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-0-4-0-0-6-payg-best-1gbps-200618231635" }
variable customImage { default = "" }
variable customUserData { default = "" }

# BIGIP Setup
variable uname {}
variable usecret {}
variable license1 { default = "" }
variable license2 { default = "" }
variable gceSshPubKey {}
variable host1_name { default = "f5vm01" }
variable host2_name { default = "f5vm02" }
variable dns_server { default = "8.8.8.8" }
variable dns_suffix {}
variable ntp_server { default = "0.us.pool.ntp.org" }
variable timezone { default = "UTC" }
variable DO_URL { default = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.13.0/f5-declarative-onboarding-1.13.0-5.noarch.rpm" }
variable AS3_URL { default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.20.0/f5-appsvcs-3.20.0-3.noarch.rpm" }
variable TS_URL { default = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.12.0/f5-telemetry-1.12.0-3.noarch.rpm" }
variable CF_URL { default = "https://github.com/F5Networks/f5-cloud-failover-extension/releases/download/v1.3.0/f5-cloud-failover-1.3.0-0.noarch.rpm" }
variable onboard_log { default = "/var/log/cloud/onboard.log" }

# BIGIQ License Manager Setup
variable bigIqHost { default = "200.200.200.200" }
variable bigIqUsername { default = "admin" }
variable bigIqLicenseType { default = "licensePool" }
variable bigIqLicensePool { default = "myPool" }
variable bigIqSkuKeyword1 { default = "key1" }
variable bigIqSkuKeyword2 { default = "key1" }
variable bigIqUnitOfMeasure { default = "hourly" }
variable bigIqHypervisor { default = "gce" }

# TAGS
variable purpose { default = "public" }
variable environment { default = "f5env" } #ex. dev/staging/prod
variable owner { default = "f5owner" }
variable group { default = "f5group" }
variable costcenter { default = "f5costcenter" }
variable application { default = "f5app" }
variable f5_cloud_failover_label { default = "mydeployment" } #Cloud Failover Tag