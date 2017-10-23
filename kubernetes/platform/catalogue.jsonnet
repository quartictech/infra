local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "catalogue",
    namespace: "platform",
    port: 8090,

    resources: {
        requests: {
            cpu: "100m",
        },
    },

    dropwizardConfig: {
        database: {
            host_name: "postgres",
            database_name: "catalogue",
            user: "postgres",
            password: $.config.postgres.password_encrypted
        },
    },
}
