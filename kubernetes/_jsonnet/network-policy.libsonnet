local k = import "../_jsonnet/k8s.libsonnet";

{
    allPods:: { podSelector: {} },
    noPods:: { podSelector: { matchLabels: {} } },
    labelSelector(key, value):: { matchLabels: { [key]: value } },
    podsWithLabel(key, value):: { podSelector: $.labelSelector(key, value) },
    namespacesWithLabel(key, value):: { namespaceSelector: $.labelSelector(key, value) },
    namespaceWithName(namespace):: $.namespacesWithLabel("name", namespace),    # Note - this relies on our conventional "name" label being set

    allow(policyName, source, target):: {
        policyName: policyName,
        spec: target {
            ingress: [
                {
                    from: [source],
                },
            ],
        },
    },

    defaultDenyAll:: $.allow(
        policyName = "none",
        source = $.noPods,
        target = $.allPods,
    ),

    allowIntraNamespace:: $.allow(
        policyName = "intra-namespace",
        source = $.allPods,
        target = $.allPods,
    ),

    # TODO - tie this down specifically to ingress-controller once that becomes possible
    allowIngress:: $.allow(
        policyName = "ingress",
        source = $.namespaceWithName("core"),
        target = $.podsWithLabel("requires-ingress", "true"),
    ),

    local _render(namespace, partial) = k.networkPolicy("allow-%s" % [partial.policyName], namespace) { spec: partial.spec },

    local _standardPolicies = [
        $.defaultDenyAll,
    ],

    policySet(namespace, policies):: k.list([_render(namespace, p) for p in _standardPolicies + policies])
}
