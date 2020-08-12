{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
      "class": "ADC",
      "schemaVersion": "3.13.0",
      "id": "${uuid}",
      "label": "ingress",
      "remark": "An HTTPS sample application",
      "controls": {
        "trace": true
      },
      "ingress: {
        "class": "Tenant",
        "nginx": {
          "class": "Application",
          "template": "https",
          "serviceMain": {
            "class": "Service_HTTPS",
            "virtualAddresses": [
              "${publicvip}",
              "${privatevip}"
            ],
            "pool": "web_pool",
            "serverTLS": "webtls",
            "profileMultiplex": {
              "bigip": "/Common/oneconnect"
            }
          },
          "web_pool": {
            "class": "Pool",
            "monitors": [
              "tcp"
            ],
            "members": [
              {
                "servicePort": 80,
                "addressDiscovery": "consul",
                "updateInterval": 10,
                "uri": "http://${consulAddress}:8500/v1/catalog/service/nginx"
              }
            ]
          },
          "webtls": {
            "class": "TLS_Server",
            "ciphers": "HIGH",
            "certificates": [{
                "certificate": "certificate_default"
            }]
          },
          "certificate_default": {
            "class": "Certificate",
            "certificate": {
                "bigip": "/Common/default.crt"
            },
            "privateKey": {
                "bigip": "/Common/default.key"
            }
         }
        }
      }
    }
  }