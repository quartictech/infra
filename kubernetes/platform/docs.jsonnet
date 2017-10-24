local q = import "../_jsonnet/quartic.libsonnet";

function (config) q.frontendService("docs", "platform", config) + {
    cpuRequest: "100m",
}
