{
    "class": "Telemetry",
    "My_System": {
        "class": "Telemetry_System",
        "systemPoller": {
            "interval": 60
        }
    },
    "My_Listener": {
        "class": "Telemetry_Listener",
        "port": 6514
    },
    "My_Consumer": {
      "class": "Telemetry_Consumer",
      "type": "Google_Cloud_Monitoring",
      "privateKey": {
          "cipherText": "$${privateKey}"
      },
      "projectId": "${gcp_project_id}",
      "privateKeyId": "${privateKeyId}",
      "serviceEmail": "${serviceAccount}"
    }
  }