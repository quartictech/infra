local np = import "../_jsonnet/network-policy.libsonnet";

local allowBackups = np.allow(
    policyName = "backups",
    source = np.namespaceWithName("backups"),
    target = np.podsWithLabel("requires-backup", "true"),
);

local allowAnalysis = np.allow(
    policyName = "analysis",
    source = np.namespaceWithName("analysis"),
    target = np.podsWithLabel("api-trust", "high"),
);

local allowSandbox = np.allow(
    policyName = "sandbox",
    source = np.namespaceWithName("sandbox"),
    target = np.podsWithLabel("api-trust", "low"),
);

# TODO - add port restrictions
np.policySet(
    namespace = "platform",
    policies = [
        np.allowIntraNamespace,         # TODO - this should only apply to particular pods
        np.allowIngress,
        allowBackups,
        allowAnalysis,
        allowSandbox,
    ],
)
