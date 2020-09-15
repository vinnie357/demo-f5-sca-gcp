{
    "schemaVersion": "1.0.0",
    "class": "Device",
    "async": true,
    "label": "Onboard BIG-IP into an HA Pair",
    "Common": {
        "class": "Tenant",
        "hostname": "$${local_host}",
        "dbVars": {
            "class": "DbVariables",
            "ui.advisory.enabled": true,
            "ui.advisory.color": "green",
            "ui.advisory.text": "/Common/hostname",
            "config.allow.rfc3927": "enable"
        },
        "myDns": {
            "class": "DNS",
            "nameServers": [
                "169.254.169.254",
                "${dns_server}",
                "2001:4860:4860::8844"
            ],
            "search": [
                "${dnsSuffix}",
                "google.internal",
                "f5.com"
            ]
        },
        "myNtp": {
            "class": "NTP",
            "servers": [
                "${ntp_server}",
                "1.pool.ntp.org",
                "2.pool.ntp.org"
            ],
            "timezone": "${timezone}"
        },
        "myProvisioning": {
            "class": "Provision",
            "ltm": "nominal",
            "asm": "nominal",
            "afm": "nominal"
        },
        "configsync": {
            "class": "ConfigSync",
            "configsyncIp": "$${local_selfip_int}"
        },
        "failoverAddress": {
            "class": "FailoverUnicast",
            "address": "$${local_selfip_int}"
        },
        "failoverGroup": {
            "class": "DeviceGroup",
            "type": "sync-failover",
            "members": ["${host1}.${dnsSuffix}", "${host2}.${dnsSuffix}"],
            "owner": "/Common/failoverGroup/members/0",
            "autoSync": true,
            "saveOnAutoSync": false,
            "networkFailover": true,
            "fullLoadOnSync": false,
            "asmSync": false
        },
        "trust": {
            "class": "DeviceTrust",
            "localUsername": "${admin_username}",
            "localPassword": "$${admin_password}",
            "remoteHost": "${remote_host}",
            "remoteUsername": "${admin_username}",
            "remotePassword": "$${admin_password}"
        }
    }
}