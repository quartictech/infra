local q = import "../_jsonnet/quartic.libsonnet";

function (config) q.backendService("howl", "platform", 8120, config) + {
    dropwizardConfig: {
        aws: config.aws,
        namespaces: { [c.registry.namespace]: c.howl for c in config.customers },
    }
}
