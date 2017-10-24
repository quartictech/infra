local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "registry",
    namespace: "platform",
    port: 8190,

    resources: {
        requests: {
            cpu: "100m",
        },
    },

    dropwizardConfig: {
        customers: std.map(function (c) c.registry, config.customers),  # TODO: this is obviously nonsense in the long run
    }
}
