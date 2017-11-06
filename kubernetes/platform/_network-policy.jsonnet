local np = import "../_jsonnet/network-policy.libsonnet";

local allowBackups = np.allow(
    policyName = "backups",
    source = np.namespaceWithName("backups"),
    target = np.podsWithLabel("requires-backup", "true"),
);

local allowSandbox = np.allow(
    policyName = "sandbox",
    source = np.namespaceWithName("sandbox"),
    target = np.podsWithLabel("api-trust", "low"),
);

local allowFringe = np.allow(
    policyName = "fringe",
    source = np.namespaceWithName("fringe"),
    target = np.podsWithLabel("api-trust", "high"),
);

local allowAnalysis = np.allow(
    policyName = "analysis",
    source = np.namespaceWithName("analysis"),
    target = np.podsWithLabel("api-trust", "high"),
);

# TODO - add port restrictions
np.policySet(
    namespace = "platform",
    policies = [
        np.allowIntraNamespace,         # TODO - this should only apply to particular pods
        np.allowIngress,
        // allowBackups,                # TODO
        allowSandbox,
        allowFringe,
        allowAnalysis,
    ],
)
