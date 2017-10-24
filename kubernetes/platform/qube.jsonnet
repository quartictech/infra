local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "qube",
    namespace: "platform",
    port: 8200,
    extraPorts: [{ port: 8202, name: "websocket" }],

    resources: {
        requests: {
            cpu: "100m",
        },
    },

    dropwizardConfig: {
        kubernetes: {
            enable: true,
            namespace: "qube",
            num_concurrent_jobs: 4,
            job_timeout_seconds: 3600,
            pod_template: {
                spec: {
                    automount_service_account_token: false,
                    containers: [
                        {
                            name: "container"
                        }
                    ],
                    restart_policy: "Never",
                },
            },
        },

        database: {
            host_name: "postgres",
            database_name: "qube",
            user: "postgres",
            password: $.config.postgres.password_encrypted,
        },

        websocket_port: 8202,
    }
}
