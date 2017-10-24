local k = import "../_jsonnet/k8s.libsonnet";
local q = import "../_jsonnet/quartic.libsonnet";

local zeusBackend(s, config) = q.backendService("zeus-%s" % [s], "fringe", 8160, config) {
    image: "zeus",

    env: {
        JAVA_OPTS: "-Xmx1g",
    },

    dropwizardConfig: {
        datasets: config.fringe.stacks[s].zeus.datasets,
    }
};

local zeusFrontend(s, config) = q.frontendService("zeus-frontend-%s" % [s], "fringe", config) {
    image: "zeus_frontend",
};

local basicAuth(s, config) = {
    apiVersion: "v1",
    kind: "Secret",
    type: "Opaque",
    metadata: {
        name: "basic-auth-%s" % [s],
        namespace: "fringe",
    },
    data: {
        auth: std.base64(config.fringe.stacks[s].auth_secret),
    },
};

local ingress(s, config) = k.ingress("ingress-%s" % [s], "fringe", config.gcloud.domain_name) {
    certs: [$.cert(s)],
    rules: [
        $.rule(s, [
            $.path("/",     "zeus-frontend-%s" % [s],   80),
            $.path("/api",  "zeus-%s" % [s],            8160),
        ]),
    ],
};

local instance(s, config) = k.list([
    zeusBackend(s, config),
    zeusFrontend(s, config),
    basicAuth(s, config),
    ingress(s, config)
]);

function (config) k.list([instance(s, config) for s in std.objectFields(config.fringe.stacks)])
