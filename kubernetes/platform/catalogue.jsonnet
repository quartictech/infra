local q = import "../_jsonnet/quartic.libsonnet";

function (config)
    q.backendService("catalogue", "platform", 8090, config) {
        dropwizardConfig: {
            database: {
                host_name: "postgres",
                database_name: "catalogue",
                user: "postgres",
                password: config.postgres.password_encrypted
            },
        },
    } +
    q.mixin.apiTrust("low")
