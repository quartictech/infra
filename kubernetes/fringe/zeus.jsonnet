local k = import "../_jsonnet/k8s.libsonnet";
local q = import "../_jsonnet/quartic.libsonnet";

local zeusBackend(s, cluster) = q.backendService("zeus-%s" % [s], "fringe", 8160, cluster) {
    imageName: "zeus",

    env: {
        JAVA_OPTS: "-Xmx1g",
    },

    dropwizardConfig: {
        datasets: cluster.fringe.stacks[s].zeus.datasets,
    }
};

local zeusFrontend(s, cluster) = q.frontendService("zeus-frontend-%s" % [s], "fringe", cluster) {
    imageName: "zeus_frontend",
};

local basicAuth(s, cluster) = k.secret {
    data: {
        auth: std.base64(cluster.fringe.stacks[s].auth_secret),
    },
};

local ingress(s, cluster) = k.ingress("ingress-%s" % [s], "fringe", cluster.gcloud.domain_name) {
    certs: [$.cert(s)],
    rules: [
        $.rule(s, [
            $.path("/",     "zeus-frontend-%s" % [s],   80),
            $.path("/api",  "zeus-%s" % [s],            8160),
        ]),
    ],
};

local instance(s, cluster) = k.list([
    zeusBackend(s, cluster),
    zeusFrontend(s, cluster),
    basicAuth(s, cluster),
    ingress(s, cluster)
]);

function (cluster) k.list([instance(s, cluster) for s in std.objectFields(cluster.fringe.stacks)])
