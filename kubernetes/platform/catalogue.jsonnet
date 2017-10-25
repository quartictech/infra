local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("catalogue", "platform", 8090, cluster) {
    dropwizardConfig: {
        database: {
            host_name: "postgres",
            database_name: "catalogue",
            user: "postgres",
            password: cluster.postgres.password_encrypted
        },
    },
}
