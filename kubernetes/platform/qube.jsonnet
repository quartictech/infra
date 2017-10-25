local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("qube", "platform", 8200, cluster) {
    extraPorts: [{ port: 8202, name: "websocket" }],

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
            password: cluster.postgres.password_encrypted,
        },

        websocket_port: 8202,
    }
}
