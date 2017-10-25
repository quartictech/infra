local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("registry", "platform", 8190, cluster) {
    dropwizardConfig: {
        customers: std.map(function (c) c.registry, cluster.customers),  # TODO: this is obviously nonsense in the long run
    }
}
