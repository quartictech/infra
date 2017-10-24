local q = import "../_jsonnet/quartic.libsonnet";

function (config) q.backendService("registry", "platform", 8190, config) {
    dropwizardConfig: {
        customers: std.map(function (c) c.registry, config.customers),  # TODO: this is obviously nonsense in the long run
    }
}
