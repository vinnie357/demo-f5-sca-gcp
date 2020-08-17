{
    "schemaVersion": "1.0.0",
    "class": "Device",
    "async": true,
    "label": "Onboard BIG-IP into an HA Pair BYOL",
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
        "myLicense": {
            "class": "License",
            "licenseType": "regKey",
            "regKey": "${regKey}"
        },
        "myDns": {
            "class": "DNS",
            "nameServers": [
                "169.254.169.254",
                "${dns_server}",
                "2001:4860:4860::8844"
            ],
            "search": [
                "${dns_suffix}",
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
            "ltm": "nominal"
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
            "members": ["${host1}.${dns_suffix}", "${host2}.${dns_suffix}"],
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