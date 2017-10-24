local quarticService = import "../_jsonnet/utils/quartic-service.libsonnet";

function (config) quarticService + {
    config: config,

    name: "howl",
    namespace: "platform",
    port: 8120,

    resources: {
        requests: {
            cpu: "100m",
        },
    },

    dropwizardConfig: {
        aws: $.config.aws,
        namespaces: { [c.registry.namespace]: c.howl for c in $.config.customers },
    }
}
