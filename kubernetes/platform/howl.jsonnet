local q = import "../_jsonnet/quartic.libsonnet";

function (cluster) q.backendService("howl", "platform", 8120, cluster) {
    dropwizardConfig: {
        aws: cluster.aws,
        namespaces: { [c.registry.namespace]: c.howl for c in cluster.customers },
    }
}
