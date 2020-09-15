# demo-f5-sca-gcp
sca in gcp using f5 technologies

- High avaliabilty pair of BIG-IP
  - Failover via API
  - LTM,ASM,AFM
- Nginx Plus
  - App Protect
- Nginx Controller
- Consul
  - service discovery
  - nginx templating
- NGINX KIC
  - ingress
- GKE

## Setup

### Requirements
- storage bucket with controller tarball

    eg: controller-installer-3.7.0.tar.gz

- Controller
  - license file
  
    [trial license](https://www.nginx.com/free-trial-request-nginx-controller/)

- Nginx plus
  - cert
  - key
  
    [trial keys](https://www.nginx.com/free-trial-request/)

### Prep

copy admin tfvars example to your own and update with your license keys

```bash
mv admin.auto.tfvars.example admin.auto.tfvars
```

update:
  - project
    - prefix
    - gcpProjectId
    - adminSourceAddress
    - gceSshPublicKey
  - nginx
    - nginxKey
    - nginxCert
    - controllerBucket
    - controllerLicense
  - bigip
    - usecret
    - dnsSuffix
    - serviceAccount

### Running

- login to terraform cloud account if using remote state
    https://www.terraform.io/docs/commands/login.html

  ```bash
  terraform login
  ```
- login to google account

  ```bash
    gcloud auth application-default login
    project="my-project"
    gcloud config set project $project
  ```
- run with script or manual

  ```bash
  . demo.sh
  ```